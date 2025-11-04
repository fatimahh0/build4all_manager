import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// splash / homes
import 'package:build4all_manager/app/splash_gate.dart';
import 'package:build4all_manager/features/auth/presentation/screens/app_login_screen.dart';
import 'package:build4all_manager/features/auth/presentation/screens/super_admin_home_screen.dart';

// owner shell + screens
import 'package:build4all_manager/features/owner/ownernav/presentation/screens/owner_nav_shell.dart';
import 'package:build4all_manager/features/owner/ownerhome/presentation/screens/owner_home_screen.dart';
import 'package:build4all_manager/features/owner/ownerprojects/presentation/screens/owner_projects_screen.dart';
import 'package:build4all_manager/features/owner/ownerrequests/presentation/screens/owner_requests_screen.dart';
import 'package:build4all_manager/features/owner/ownerprofile/presentation/screens/owner_profile_screen.dart';

// l10n
import 'package:build4all_manager/l10n/app_localizations.dart';

// auth repo + jwt store
import 'package:build4all_manager/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:build4all_manager/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:build4all_manager/features/auth/data/services/auth_api.dart';
import 'package:build4all_manager/features/auth/data/datasources/jwt_local_datasource.dart';
import 'package:build4all_manager/features/auth/domain/usecases/get_role_usecase.dart';

// owner register flow
import 'package:build4all_manager/features/auth/domain/usecases/OwnerCompleteProfile.dart';
import 'package:build4all_manager/features/auth/domain/usecases/OwnerSendOtp.dart';
import 'package:build4all_manager/features/auth/domain/usecases/OwnerVerifyOtp.dart';
import 'package:build4all_manager/features/auth/presentation/bloc/register/OwnerRegisterBloc.dart';
import 'package:build4all_manager/features/auth/presentation/screens/register/owner_register_email_screen.dart';
import 'package:build4all_manager/features/auth/presentation/screens/register/owner_register_otp_screen.dart';
import 'package:build4all_manager/features/auth/presentation/screens/register/owner_register_profile_screen.dart';

// shared Dio
import 'package:build4all_manager/core/network/dio_client.dart';

// JWT helpers
import 'package:build4all_manager/core/auth/jwt_claims.dart';

/// simple DI helper for the register flow
Widget _withOwnerRegBloc(Widget child) {
  final IAuthRepository repo =
      AuthRepositoryImpl(api: AuthApi(), jwtStore: JwtLocalDataSource());
  return BlocProvider(
    create: (_) => OwnerRegisterBloc(
      OwnerSendOtpUseCase(repo),
      OwnerVerifyOtpUseCase(repo),
      OwnerCompleteProfileUseCase(repo),
    ),
    child: child,
  );
}

const _publicPaths = <String>{
  '/',
  '/login',
  '/loginScreen',
  '/owner/register',
  '/owner/register/otp',
  '/owner/register/profile',
};

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashGate()),
    GoRoute(path: '/login', builder: (_, __) => const AppLoginScreen()),
    GoRoute(path: '/loginScreen', builder: (_, __) => const AppLoginScreen()),
    GoRoute(path: '/manager', builder: (_, __) => const SuperAdminHomeScreen()),

    // OWNER shell – ownerId resolved from JWT
    GoRoute(path: '/owner', builder: (_, __) => const _OwnerEntryLoader()),

    // Deep links under OWNER
    GoRoute(
      path: '/owner/projects',
      builder: (_, __) => const _OwnerProjectsBuilder(),
    ),

    // 🔥 Profile deep-link — opens shell on the Profile tab
    GoRoute(
      path: '/owner/profile',
      builder: (_, __) => const _OwnerEntryLoader(initialIndex: 3),
    ),

    // Register flow
    GoRoute(
      path: '/owner/register',
      builder: (_, __) => _withOwnerRegBloc(const OwnerRegisterEmailScreen()),
      routes: [
        GoRoute(
          path: 'otp',
          builder: (ctx, st) {
            final extra = (st.extra ?? {}) as Map;
            return _withOwnerRegBloc(
              OwnerRegisterOtpScreen(
                email: (extra['email'] ?? '') as String,
                password: (extra['password'] ?? '') as String,
              ),
            );
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (ctx, st) => _withOwnerRegBloc(
            OwnerRegisterProfileScreen(
              registrationToken: (st.extra ?? '') as String,
            ),
          ),
        ),
      ],
    ),
  ],
  redirect: _authRedirect,
);

Future<String?> _authRedirect(BuildContext context, GoRouterState state) async {
  final IAuthRepository repo =
      AuthRepositoryImpl(api: AuthApi(), jwtStore: JwtLocalDataSource());

  final role = (await GetStoredRoleUseCase(repo).call()).toUpperCase();
  final loc = state.matchedLocation;
  final isPublic = _publicPaths.contains(loc);

  if (role.isEmpty) return isPublic ? null : '/login';

  final goingToAuth =
      loc.startsWith('/login') || loc.startsWith('/owner/register');
  if (goingToAuth) return role == 'SUPER_ADMIN' ? '/manager' : '/owner';

  if (role == 'SUPER_ADMIN' && (loc == '/owner' || loc == '/home')) {
    return '/manager';
  }
  if (role != 'SUPER_ADMIN' && (loc == '/manager' || loc == '/home')) {
    return '/owner';
  }

  return null;
}

/// -------- ownerId from JWT (async) ----------
Future<int?> _loadOwnerIdFromJwt() async {
  try {
    final store = JwtLocalDataSource();
    final (token, _) = await store.read();
    if (token.isEmpty) return null;

    final claims = JwtClaims.decode(token);
    // Your payload style: {"id":1,"role":"OWNER", ...}
    final id =
        JwtClaims.extractInt(claims, ['id', 'ownerId', 'adminId', 'sub']);
    return id;
  } catch (_) {
    return null;
  }
}

/// Loads ownerId then mounts OwnerEntry
class _OwnerEntryLoader extends StatelessWidget {
  final int initialIndex; // 👈 NEW
  const _OwnerEntryLoader({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<int?>(
      future: _loadOwnerIdFromJwt(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final ownerId = snap.data;
        if (ownerId == null) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => context.go('/login'));
          return Scaffold(body: Center(child: Text(l10n.owner_nav_profile)));
        }
        final Dio dio = DioClient.ensure();
        return OwnerEntry(
          ownerId: ownerId,
          dio: dio,
          backendMenuType: 'bottom',
          initialIndex: initialIndex, // 👈 pass it down
        );
      },
    );
  }
}

/// Builds OwnerProjectsScreen with ownerId from JWT (direct link support)
class _OwnerProjectsBuilder extends StatelessWidget {
  const _OwnerProjectsBuilder({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: _loadOwnerIdFromJwt(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final ownerId = snap.data;
        if (ownerId == null) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => context.go('/login'));
          return const SizedBox.shrink();
        }
        final Dio dio = DioClient.ensure();
        return OwnerProjectsScreen(ownerId: ownerId, dio: dio);
      },
    );
  }
}

// OwnerEntry with the real Profile screen + deep-linking index
class OwnerEntry extends StatelessWidget {
  final String? backendMenuType; // "bottom" | "top" | "drawer"
  final int ownerId;
  final Dio dio;
  final int initialIndex; // 👈 NEW

  const OwnerEntry({
    super.key,
    required this.ownerId,
    required this.dio,
    this.backendMenuType,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final destinations = <OwnerDestination>[
      OwnerDestination(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
        label: l10n.owner_nav_home,
        page: OwnerHomeScreen(ownerId: ownerId, dio: dio),
      ),
      OwnerDestination(
        icon: Icons.widgets_outlined,
        selectedIcon: Icons.widgets_rounded,
        label: l10n.owner_nav_projects,
        page: OwnerProjectsScreen(ownerId: ownerId, dio: dio),
      ),
      OwnerDestination(
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long_rounded,
        label: l10n.owner_nav_requests,
        page: OwnerRequestScreen(ownerId: ownerId),
      ),
      // in router.dart, inside OwnerEntry.build()
      OwnerDestination(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: l10n.owner_nav_profile,
        page: OwnerProfileScreen(ownerId: ownerId, dio: dio),
      ),

    ];

    return OwnerNavShell(
      destinations: destinations,
      backendMenuType: backendMenuType ?? 'bottom',
      initialIndex: initialIndex, // 👈 respect deep-link index
    );
  }
}
