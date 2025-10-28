import 'package:build4all_manager/core/network/dio_client.dart';
import 'package:build4all_manager/features/owner/ownerprojects/presentation/screens/owner_projects_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// splash / homes
import 'package:build4all_manager/app/splash_gate.dart';
import 'package:build4all_manager/features/auth/presentation/screens/super_admin_home_screen.dart';

// login
import 'package:build4all_manager/features/auth/presentation/screens/app_login_screen.dart';

// owner shell + owner screens
import 'package:build4all_manager/features/owner/ownernav/presentation/screens/owner_nav_shell.dart';
import 'package:build4all_manager/features/owner/ownerhome/presentation/screens/owner_home_screen.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';

// auth repo + usecases
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


import 'package:dio/dio.dart';

/// helper for owner registration bloc
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

/// Public routes (no auth required)
const _publicPaths = <String>{
  '/login',
  '/loginScreen',
  '/owner/register',
  '/owner/register/otp',
  '/owner/register/profile',
  '/',
};

final router = GoRouter(
  initialLocation: '/', // SplashGate decides
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashGate()),
    GoRoute(path: '/login', builder: (_, __) => const AppLoginScreen()),
    GoRoute(path: '/loginScreen', builder: (_, __) => const AppLoginScreen()),
    GoRoute(path: '/manager', builder: (_, __) => const SuperAdminHomeScreen()),

    // OWNER shell (bottom nav + tabs)
    GoRoute(
      path: '/owner',
      builder: (context, state) {
        // TODO: extract from JWT
        final ownerId = 1;
        final Dio dio = DioClient.ensure(); // ✅ shared client
        return OwnerEntry(
          ownerId: ownerId,
          dio: dio,
          backendMenuType: 'bottom',
        );
      },
    ),

    // Deep-link to Projects screen
    GoRoute(
      path: '/owner/projects',
      builder: (context, state) {
        final ownerId = 1; // TODO: from JWT
        final Dio dio = DioClient.ensure(); // ✅ shared client
        return OwnerProjectsScreen(ownerId: ownerId, dio: dio);
      },
    ),

    // Owner register
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
          builder: (ctx, st) {
            final token = (st.extra ?? '') as String;
            return _withOwnerRegBloc(
              OwnerRegisterProfileScreen(registrationToken: token),
            );
          },
        ),
      ],
    ),
  ],
  redirect: _authRedirect,
);

/// Central auth redirect
Future<String?> _authRedirect(BuildContext context, GoRouterState state) async {
  final IAuthRepository repo =
      AuthRepositoryImpl(api: AuthApi(), jwtStore: JwtLocalDataSource());

  final role = (await GetStoredRoleUseCase(repo).call()).toUpperCase();
  final loc = state.matchedLocation;
  final isPublic = _publicPaths.contains(loc);

  if (role.isEmpty) {
    return isPublic ? null : '/login';
  }

  final goingToAuthOrRegister =
      loc.startsWith('/login') || loc.startsWith('/owner/register');

  if (goingToAuthOrRegister) {
    if (role == 'SUPER_ADMIN') return '/manager';
    return '/owner';
  }

  if (role == 'SUPER_ADMIN' && (loc == '/owner' || loc == '/home'))
    return '/manager';
  if (role != 'SUPER_ADMIN' && (loc == '/manager' || loc == '/home'))
    return '/owner';

  return null;
}

/// OwnerEntry mounts the Owner shell with tabs
class OwnerEntry extends StatelessWidget {
  final String? backendMenuType; // "bottom" | "top" | "drawer"
  final int ownerId;
  final Dio dio;

  const OwnerEntry({
    super.key,
    required this.ownerId,
    required this.dio,
    this.backendMenuType,
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
        page: const _Placeholder('Requests'),
      ),
      OwnerDestination(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: l10n.owner_nav_profile,
        page: const _Placeholder('Profile'),
      ),
    ];

    return OwnerNavShell(
      destinations: destinations,
      backendMenuType: backendMenuType ?? 'bottom',
      initialIndex: 0,
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String text;
  const _Placeholder(this.text, {super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text(text)));
}
