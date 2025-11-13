// lib/features/owner/ownerprofile/presentation/screens/owner_profile_screen.dart
import 'package:build4all_manager/features/auth/data/datasources/jwt_local_datasource.dart';
import 'package:build4all_manager/features/owner/ownerprofile/data/repositories/owner_profile_repository_impl.dart';
import 'package:build4all_manager/features/owner/ownerprofile/data/services/owner_profile_api.dart';
import 'package:build4all_manager/features/owner/ownerprofile/domain/usecases/get_owner_profile_usecase.dart';
import 'package:build4all_manager/features/owner/ownerprofile/presentation/bloc/owner_profile_bloc.dart';
import 'package:build4all_manager/features/owner/ownerprofile/presentation/bloc/owner_profile_event.dart';
import 'package:build4all_manager/features/owner/ownerprofile/presentation/bloc/owner_profile_state.dart';
import 'package:build4all_manager/features/owner/ownerprofile/presentation/widgets/profile_header.dart';
import 'package:build4all_manager/features/owner/ownerprofile/presentation/widgets/profile_info_card.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';
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

  Future<void> _logoutFlow(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final bool? confirm = await showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        final tt = Theme.of(ctx).textTheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  l10n.logout_confirm ?? 'Do you want to log out?',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  l10n.owner_nav_profile,
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                leading: CircleAvatar(
                  backgroundColor: cs.error.withOpacity(.12),
                  child: Icon(Icons.logout, color: cs.error),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text(l10n.cancel ?? 'Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text(l10n.logout ?? 'Logout'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (confirm != true) return;

    // Clear stored JWT
    final store = JwtLocalDataSource();
    await store.clear();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.logged_out ?? 'Logged out')));
      context.go('/login'); // replace stack
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<OwnerProfileBloc, OwnerProfileState>(
      builder: (context, s) {
        final appBar = _ProfileAppBar(onLogout: () => _logoutFlow(context));

        if (s.loading) {
          return Scaffold(
            appBar: appBar,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (s.error != null) {
          return Scaffold(
            appBar: appBar,
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
              appBar: appBar,
              body: Center(child: Text(l10n.owner_nav_profile)));
        }

        return Scaffold(
          appBar: appBar,
          body: RefreshIndicator(
            onRefresh: () async =>
                context.read<OwnerProfileBloc>().add(OwnerProfileRefreshed()),
            child: LayoutBuilder(
              builder: (context, c) {
                final bool wide = c.maxWidth >= 860;
                final EdgeInsets pagePad = EdgeInsets.symmetric(
                    horizontal: wide ? 24 : 12, vertical: 12);

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: pagePad,
                    child: Column(
                      children: [
                        // ===== Header (cover + avatar + quick actions) =====
                        ProfileHeader(p: p),

                        const SizedBox(height: 16),

                        // ===== Content grid (adaptive) =====
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            SizedBox(
                              width: _cardWidth(c.maxWidth, min: 320, max: 680),
                              child: ProfileInfoCard(p: p),
                            ),
                            SizedBox(
                              width: _cardWidth(c.maxWidth, min: 320, max: 680),
                              child: _SettingsCard(
                                  onLogout: () => _logoutFlow(context)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  double _cardWidth(double maxWidth,
      {required double min, required double max}) {
    // Simple responsive: two columns on wide, one on narrow
    if (maxWidth >= 980) return max; // wide card
    if (maxWidth >= 720) return (maxWidth - 16 /*wrap gap*/) / 2;
    return maxWidth - 24; // page padding fallback
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
    final cs = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(l10n.owner_nav_profile),
      actions: [
        IconButton(
          tooltip: l10n.logout ?? 'Logout',
          onPressed: onLogout,
          icon: Icon(Icons.logout_rounded, color: cs.onSurface),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final VoidCallback onLogout;
  const _SettingsCard({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    Widget tile({
      required IconData icon,
      required String label,
      String? caption,
      Color? tint,
      VoidCallback? onTap,
      Widget? trailing,
    }) {
      final color = tint ?? cs.primary;
      return ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: color.withOpacity(.12),
          child: Icon(icon, color: color),
        ),
        title: Text(label,
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        subtitle: caption == null
            ? null
            : Text(caption,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
      );
    }

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant.withOpacity(.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
           
            /*       tile(
              icon: Icons.person_outline_rounded,
              label: l10n.owner_profile_edit ?? 'Account',
              caption: l10n.owner_profile_name,
              onTap: () {
                // TODO: navigate to account edit    
              },
            ),
            tile(
              icon: Icons.lock_outline_rounded,
              label: l10n.security ?? 'Security',
              caption: l10n.change_password ?? 'Change password',
              onTap: () {
                // TODO: navigate to security
              },
            ),
            tile(
              icon: Icons.help_outline_rounded,
              label: l10n.support ?? 'Support',
              caption: l10n.contact_us ?? 'Contact us',
              onTap: () {
                // TODO: support action
              },
            ), */
            const Divider(height: 8),
            tile(
              icon: Icons.logout_rounded,
              label: l10n.logout ?? 'Logout',
              caption: l10n.logout_confirm ?? 'Sign out from this device',
              tint: cs.error,
              trailing: const Icon(Icons.exit_to_app_rounded),
              onTap: onLogout,
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
