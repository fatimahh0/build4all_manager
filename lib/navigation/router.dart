import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../features/super_admin_auth/presentation/bloc/auth_bloc.dart';
import '../features/super_admin_auth/presentation/screens/super_admin_home_screen.dart';
import '../features/super_admin_auth/presentation/screens/super_admin_login_screen.dart';
import 'route_guard.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const SuperAdminLoginScreen()),
    GoRoute(
      path: '/super-admin',
      builder: (context, state) {
        // provide an AuthBloc above home if you plan to use it there
        return BlocProvider.value(
          value: context
              .read<AuthBloc>(), // if none in context, switch to a new provider
          child: const SuperAdminHomeScreen(),
        );
      },
    ),
    GoRoute(path: '/', builder: (_, __) => const SuperAdminLoginScreen()),
  ],
  redirect: authRedirect,
);
