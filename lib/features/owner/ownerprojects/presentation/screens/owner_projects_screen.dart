import 'package:build4all_manager/features/owner/common/data/repositories/owner_repository_impl.dart';
import 'package:build4all_manager/features/owner/common/data/services/owner_api.dart';
import 'package:build4all_manager/features/owner/common/domain/usecases/get_my_apps_uc.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/owner_projects_bloc.dart';
import '../bloc/owner_projects_event.dart';
import '../bloc/owner_projects_state.dart';
import '../widgets/project_tile.dart';

class OwnerProjectsScreen extends StatelessWidget {
  final int ownerId;
  final Dio dio;

  const OwnerProjectsScreen({
    super.key,
    required this.ownerId,
    required this.dio,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final repo = OwnerRepositoryImpl(OwnerApi(dio));

    String _serverRootNoApi(Dio d) {
      final base = d.options.baseUrl; // e.g. http://192.168.1.3:8080/api
      return base.replaceFirst(RegExp(r'/api/?$'), '');
    }

    Future<void> _refresh(BuildContext ctx) async {
      ctx.read<OwnerProjectsBloc>().add(OwnerProjectsStarted(ownerId));
      await Future.delayed(const Duration(milliseconds: 350));
    }

    return BlocProvider(
      create: (_) => OwnerProjectsBloc(getMyApps: GetMyAppsUc(repo))
        ..add(OwnerProjectsStarted(ownerId)),
      child: Scaffold(
        backgroundColor: cs.background,
        body: SafeArea(
          child: BlocBuilder<OwnerProjectsBloc, OwnerProjectsState>(
            builder: (context, state) {
              final l10n = AppLocalizations.of(context)!;

              // Always allow pull-to-refresh
              return RefreshIndicator(
                onRefresh: () => _refresh(context),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    // ---------- Top AppBar-like header ----------
                    SliverToBoxAdapter(
                      child: _Header(
                        onOnlyReadyToggle: () => context
                            .read<OwnerProjectsBloc>()
                            .add(const OwnerProjectsToggleOnlyReady()),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),

                    // ---------- Search ----------
                    SliverToBoxAdapter(child: _SearchField(l10n: l10n)),
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),

                    // ---------- Content ----------
                    if (state.loading) ...[
                      const _GridSkeleton(),
                    ] else if (state.error != null) ...[
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _CenteredMessage(
                          icon: Icons.error_outline_rounded,
                          label: state.error!,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ] else if (state.filtered.isEmpty) ...[
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyProjects(l10n: l10n),
                      ),
                    ] else ...[
                      SliverPadding(
                        padding: const EdgeInsets.only(bottom: 16),
                        sliver: SliverLayoutBuilder(
                          builder: (context, constraints) {
                            // Responsive: compute a *max tile width* and let grid wrap
                            final maxCrossAxisExtent =
                                _maxTileWidth(constraints.crossAxisExtent);
                            final aspect =
                                _aspectFor(constraints.crossAxisExtent);

                            return SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: maxCrossAxisExtent,
                                childAspectRatio: aspect,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final item = state.filtered[index];
                                  return ProjectTile(
                                    project: item,
                                    serverRootNoApi: _serverRootNoApi(dio),
                                  );
                                },
                                childCount: state.filtered.length,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // wider screen → allow ~280–320px tiles; tiny screens → ~220–240px
  double _maxTileWidth(double crossExtent) {
    if (crossExtent < 360) return 220;
    if (crossExtent < 420) return 240;
    if (crossExtent < 520) return 260;
    if (crossExtent < 760) return 280;
    if (crossExtent < 1000) return 300;
    return 320;
  }

  // slightly taller on narrow screens so content never overflows
  double _aspectFor(double crossExtent) {
    if (crossExtent < 360) return 0.92;
    if (crossExtent < 420) return 1.00;
    if (crossExtent < 520) return 1.06;
    if (crossExtent < 760) return 1.12;
    return 1.18;
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onOnlyReadyToggle;
  const _Header({required this.onOnlyReadyToggle});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.owner_projects_title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  '', // add this in l10n if not there
                  style: tt.bodyMedium
                      ?.copyWith(color: cs.onSurface.withOpacity(.65)),
                ),
              ],
            ),
          ),
          BlocBuilder<OwnerProjectsBloc, OwnerProjectsState>(
            buildWhen: (p, c) => p.onlyReady != c.onlyReady,
            builder: (context, state) {
              return InkWell(
                onTap: onOnlyReadyToggle,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: state.onlyReady
                        ? cs.primary.withOpacity(.12)
                        : cs.surfaceVariant.withOpacity(.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (state.onlyReady ? cs.primary : cs.outlineVariant)
                          .withOpacity(.6),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        state.onlyReady
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked,
                        size: 18,
                        color:
                            state.onlyReady ? cs.primary : cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.owner_projects_onlyReady,
                        style: tt.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: state.onlyReady
                              ? cs.primary
                              : cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final AppLocalizations l10n;
  const _SearchField({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (v) => context
            .read<OwnerProjectsBloc>()
            .add(OwnerProjectsSearchChanged(v)),
        style: tt.bodyMedium,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon:
              Icon(Icons.tune_rounded, color: cs.onSurface.withOpacity(.55)),
          hintText: l10n.owner_projects_searchHint,
          filled: true,
          fillColor: cs.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: cs.outlineVariant),
          ),
        ),
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _CenteredMessage({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: color ?? cs.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(label,
                textAlign: TextAlign.center,
                style: tt.bodyLarge?.copyWith(color: (color ?? cs.onSurface))),
          ],
        ),
      ),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  final AppLocalizations l10n;
  const _EmptyProjects({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.widgets_outlined, size: 60, color: cs.outline),
          const SizedBox(height: 10),
          Text(l10n.owner_projects_emptyTitle,
              textAlign: TextAlign.center,
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            l10n.owner_projects_emptyBody,
            textAlign: TextAlign.center,
            style: tt.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(.7)),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () =>
                Navigator.of(context).pushNamed('/owner/request-new'),
            icon: const Icon(Icons.bolt_rounded),
            label: Text(l10n.owner_home_requestApp),
          ),
        ],
      ),
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 280,
          childAspectRatio: 1.06,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, _) => Container(
            decoration: BoxDecoration(
              color: cs.surfaceVariant.withOpacity(.5),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          childCount: 6,
        ),
      ),
    );
  }
}
