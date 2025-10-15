// lib/app/router.dart
import 'package:build4all_manager/features/auth/domain/usecases/OwnerCompleteProfile.dart';
import 'package:build4all_manager/features/auth/domain/usecases/OwnerSendOtp.dart';
import 'package:build4all_manager/features/auth/domain/usecases/OwnerVerifyOtp.dart';
import 'package:build4all_manager/features/auth/presentation/bloc/register/OwnerRegisterBloc.dart';
import 'package:build4all_manager/features/auth/presentation/screens/register/owner_register_email_screen.dart';
import 'package:build4all_manager/features/auth/presentation/screens/register/owner_register_otp_screen.dart';
import 'package:build4all_manager/features/auth/presentation/screens/register/owner_register_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// splash / homes
import 'package:build4all_manager/app/splash_gate.dart';
import 'package:build4all_manager/features/auth/presentation/screens/super_admin_home_screen.dart';
import 'package:build4all_manager/features/manager/homescreen/presentation/screens/manager_home_screen.dart';

// login screen
import 'package:build4all_manager/features/auth/presentation/screens/app_login_screen.dart';


// repo/api for auth + owner register usecases
import 'package:build4all_manager/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:build4all_manager/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:build4all_manager/features/auth/data/services/auth_api.dart';
import 'package:build4all_manager/features/auth/data/datasources/jwt_local_datasource.dart';
import 'package:build4all_manager/features/auth/domain/usecases/get_role_usecase.dart';

// owner register bloc + usecases

/// Lightweight factory for owner registration bloc wiring
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
  initialLocation: '/', // SplashGate decides first navigation
  routes: [
    // Splash
    GoRoute(path: '/', builder: (_, __) => const SplashGate()),

    // Auth (login)
    GoRoute(path: '/login', builder: (_, __) => const AppLoginScreen()),
    // Alias kept for compatibility
    GoRoute(path: '/loginScreen', builder: (_, __) => const AppLoginScreen()),

    // SUPER_ADMIN home (your "manager" shell naming)
    GoRoute(path: '/manager', builder: (_, __) => const SuperAdminHomeScreen()),

    // Owner / Manager common home (your existing manager screen)
    GoRoute(path: '/home', builder: (_, __) => const ManagerHomeScreen()),

    // Owner register (email → otp → profile)
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

/// Central auth redirect:
/// - If not logged in → only allow public paths (login + owner register + splash)
/// - If logged in:
///     SUPER_ADMIN  → keep away from /login & register → go /manager
///     others       → keep away from /login & register → go /home
Future<String?> _authRedirect(BuildContext context, GoRouterState state) async {
  final IAuthRepository repo =
      AuthRepositoryImpl(api: AuthApi(), jwtStore: JwtLocalDataSource());

  final role = (await GetStoredRoleUseCase(repo).call()).toUpperCase();
  final loc = state.matchedLocation;

  final isPublic = _publicPaths.contains(loc);

  // Not logged in: allow only public paths
  if (role.isEmpty) {
    return isPublic ? null : '/login';
  }

  // Logged in: bounce away from login/register to role home
  final goingToAuthOrRegister =
      loc.startsWith('/login') || loc.startsWith('/owner/register');

  if (goingToAuthOrRegister) {
    if (role == 'SUPER_ADMIN') return '/manager';
    return '/home'; // OWNER, MANAGER, etc.
  }

  // If already at a role-incompatible page, normalize:
  if (role == 'SUPER_ADMIN' && loc == '/home') return '/manager';
  if (role != 'SUPER_ADMIN' && loc == '/manager') return '/home';

  return null; // no redirect
}
