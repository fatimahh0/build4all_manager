import 'package:build4all_manager/app/splash_gate.dart';
import 'package:build4all_manager/features/auth/presentation/screens/super_admin_home_screen.dart';
import 'package:build4all_manager/features/manager/homescreen/presentation/screens/manager_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/data/datasources/jwt_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/services/auth_api.dart';
import '../../features/auth/domain/repositories/i_auth_repository.dart';
import '../../features/auth/domain/usecases/get_role_usecase.dart';
import '../../features/auth/presentation/screens/app_login_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const AppLoginScreen()),
    GoRoute(path: '/manager', builder: (_, __) => const SuperAdminHomeScreen()),
    GoRoute(path: '/home', builder: (_, __) => const ManagerHomeScreen()),
    GoRoute(path: '/loginScreen', builder: (_, __) => const AppLoginScreen()),
    GoRoute(path: '/', builder: (_, __) => const SplashGate()),
  ],
  redirect: _authRedirect,
);

Future<String?> _authRedirect(BuildContext context, GoRouterState state) async {
  // lightweight inline wiring (replace with get_it if you have it)
  final IAuthRepository repo =
      AuthRepositoryImpl(api: AuthApi(), jwtStore: JwtLocalDataSource());

  final role = (await GetStoredRoleUseCase(repo).call()).toUpperCase();
  final atLogin = state.matchedLocation == '/login';

  if (role.isEmpty && !atLogin) return '/login';
  if (role == 'SUPER_ADMIN' && atLogin) return '/manager';
  if (role != 'SUPER_ADMIN' && role.isNotEmpty && atLogin) return '/home';
  return null;
}
