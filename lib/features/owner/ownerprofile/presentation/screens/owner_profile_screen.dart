import 'package:build4all_manager/features/owner/ownerprofile/data/repositories/owner_profile_repository_impl.dart';
import 'package:build4all_manager/features/owner/ownerprofile/data/services/owner_profile_api.dart';
import 'package:build4all_manager/features/owner/ownerprofile/domain/usecases/get_owner_profile_usecase.dart';
import 'package:build4all_manager/features/owner/ownerprofile/presentation/bloc/owner_profile_bloc.dart';
import 'package:build4all_manager/features/owner/ownerprofile/presentation/bloc/owner_profile_event.dart';
import 'package:build4all_manager/features/owner/ownerprofile/presentation/bloc/owner_profile_state.dart';
import 'package:build4all_manager/features/owner/ownerprofile/presentation/widgets/profile_header.dart';
import 'package:build4all_manager/features/owner/ownerprofile/presentation/widgets/profile_info_card.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';
import 'package:build4all_manager/features/auth/data/datasources/jwt_local_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OwnerProfileScreen extends StatelessWidget {
  final int? ownerId; // optional: if provided, fetch by id; else /me
  final Dio dio;

  const OwnerProfileScreen({super.key, required this.dio, this.ownerId});

  @override
  Widget build(BuildContext context) {
    final repo = OwnerProfileRepositoryImpl(OwnerProfileApi(dio));
    final uc = GetOwnerProfileUseCase(repo);

    return BlocProvider(
      create: (_) => OwnerProfileBloc(getProfile: uc)
        ..add(OwnerProfileStarted(adminId: ownerId)),
      child: const _OwnerProfileView(),
    );
  }
}

class _OwnerProfileView extends StatelessWidget {
  const _OwnerProfileView();

  Future<void> _logout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.owner_nav_profile),
        content: Text(l10n.logout_confirm ?? 'Do you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel ?? 'Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.logout ?? 'Logout'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    // Clear stored JWT (and any cached refresh data if you add that later)
    final store = JwtLocalDataSource();
    await store.clear();

    // Optional: show a tiny toast/snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.logged_out ?? 'Logged out')),
    );

    // Navigate to login (replace stack)
    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<OwnerProfileBloc, OwnerProfileState>(
      builder: (context, s) {
        if (s.loading) {
          return const Scaffold(
            appBar: _ProfileAppBar(),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (s.error != null) {
          return Scaffold(
            appBar: _ProfileAppBar(onLogout: () => _logout(context)),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(s.error!, textAlign: TextAlign.center),
              ),
            ),
          );
        }
        final p = s.profile;
        if (p == null) {
          return Scaffold(
            appBar: _ProfileAppBar(onLogout: () => _logout(context)),
            body: Center(child: Text(l10n.owner_nav_profile)),
          );
        }
        return Scaffold(
          appBar: _ProfileAppBar(onLogout: () => _logout(context)),
          body: RefreshIndicator(
            onRefresh: () async =>
                context.read<OwnerProfileBloc>().add(OwnerProfileRefreshed()),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(.25),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ProfileHeader(p: p),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProfileInfoCard(p: p),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onLogout;
  const _ProfileAppBar({this.onLogout});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(l10n.owner_nav_profile),
      actions: [
        IconButton(
          tooltip: l10n.logout ?? 'Logout',
          onPressed: onLogout,
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }
}
