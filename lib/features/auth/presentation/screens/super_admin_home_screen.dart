import 'package:build4all_manager/core/network/dio_client.dart';
import 'package:build4all_manager/features/superadmin/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:build4all_manager/features/superadmin/nav/super_admin_nav_shell.dart';
import 'package:build4all_manager/features/superadmin/profile/presentation/screens/profile_screen.dart';
import 'package:build4all_manager/features/superadmin/themes/data/repositories/theme_repository_impl.dart';
import 'package:build4all_manager/features/superadmin/themes/data/services/theme_api.dart';
import 'package:build4all_manager/features/superadmin/themes/presentation/bloc/theme_bloc.dart';
import 'package:build4all_manager/features/superadmin/themes/presentation/bloc/theme_event.dart';
import 'package:build4all_manager/features/superadmin/themes/presentation/screens/themes_screen.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class SuperAdminHomeScreen extends StatelessWidget {
  /// pass "top" | "bottom" | "drawer" from backend active theme if you have it
  final String? menuType;

  /// force a mode for testing: SuperMenuType.top / bottom / drawer
  final SuperMenuType? overrideMenu;

  const SuperAdminHomeScreen({
    super.key,
    this.menuType,
    this.overrideMenu,
  });

  @override
  Widget build(BuildContext context) {
    final Dio dio = DioClient.ensure();
    final l10n = AppLocalizations.of(context)!;

    // IMPORTANT: the first destination is Dashboard → it opens first after login
    final destinations = [
      SuperAdminDestination(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        label: l10n.nav_dashboard,
        // 🔧 FIX: remove const to avoid "Not a constant expression"
        page: DashboardScreen(),
      ),
      SuperAdminDestination(
        icon: Icons.palette_outlined,
        selectedIcon: Icons.palette,
        label: l10n.nav_themes,
        // 🔧 FIX: remove const (safe either way)
        page: ThemesScreen(),
      ),
      SuperAdminDestination(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: l10n.nav_profile,
        // 🔧 FIX: remove const (this was the crash)
        page: SuperAdminProfileScreen(),
      ),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ThemeBloc(ThemeRepositoryImpl(ThemeApi(dio)))..add(LoadThemes()),
        ),
      ],
      child: SuperAdminNavShell(
        destinations: destinations,
        backendMenuType: menuType, // e.g. "drawer" from /api/themes/active
        override: overrideMenu, // set for local testing, otherwise null
      ),
    );
  }
}
