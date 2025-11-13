import 'package:build4all_manager/features/owner/common/data/repositories/owner_repository_impl.dart';
import 'package:build4all_manager/features/owner/common/data/services/owner_api.dart';
import 'package:build4all_manager/features/owner/common/domain/entities/owner_project.dart';
import 'package:build4all_manager/features/owner/common/domain/usecases/get_my_apps_uc.dart';
import 'package:build4all_manager/features/owner/ownerprojects/presentation/widgets/project_tile.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';
import 'package:build4all_manager/shared/widgets/top_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/owner_projects_bloc.dart';
import '../bloc/owner_projects_event.dart';
import '../bloc/owner_projects_state.dart';

class OwnerProjectsScreen extends StatefulWidget {
  final int ownerId;
  final Dio dio;

  const OwnerProjectsScreen({
    super.key,
    required this.ownerId,
    required this.dio,
  });

  @override
  State<OwnerProjectsScreen> createState() => _OwnerProjectsScreenState();
}

class _OwnerProjectsScreenState extends State<OwnerProjectsScreen> {
  // How many cards we show at a time
  static const int _pageSize = 12;
  int _visibleCount = _pageSize;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final repo = OwnerRepositoryImpl(OwnerApi(widget.dio));

    String _serverRootNoApi(Dio d) {
      final base = d.options.baseUrl; // http://host:8080/api
      return base.replaceFirst(RegExp(r'/api/?$'), '');
    }

    Future<void> _refresh(BuildContext ctx) async {
      ctx.read<OwnerProjectsBloc>().add(OwnerProjectsStarted(widget.ownerId));
      // when refreshing, reset visible count
      setState(() {
        _visibleCount = _pageSize;
      });
      await Future.delayed(const Duration(milliseconds: 250));
    }

    Future<void> _rebuildAndRefresh(BuildContext ctx, OwnerProject p) async {
      try {
        await repo.rebuildAppLink(ownerId: widget.ownerId, linkId: p.linkId);
        if (ctx.mounted) {
          showTopToast(ctx, 'Rebuild queued', type: ToastType.success);
        }
        ctx
            .read<OwnerProjectsBloc>()
            .add(OwnerProjectsRefreshed(widget.ownerId));
      } catch (e) {
        if (ctx.mounted) {
          showTopToast(
            ctx,
            'Rebuild failed: $e',
            type: ToastType.error,
            haptics: true,
          );
        }
      }
    }

    return BlocProvider(
      create: (_) => OwnerProjectsBloc(getMyApps: GetMyAppsUc(repo))
        ..add(OwnerProjectsStarted(widget.ownerId)),
      child: Scaffold(
        backgroundColor: cs.background,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, viewport) {
              final double maxContentWidth =
                  _maxContentWidth(viewport.maxWidth);
              final double hPad = _contentHPad(viewport.maxWidth);

              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPad),
                    child: BlocBuilder<OwnerProjectsBloc, OwnerProjectsState>(
                      builder: (context, state) {
                        final l10n = AppLocalizations.of(context)!;
                        final gridConfig = _gridConfig(viewport.maxWidth);
                        final double gridBottom = gridConfig.bottomPad;

                        // number of items we REALLY show now
                        final int total = state.filtered.length;
                        final int visible =
                            total == 0 ? 0 : _visibleCount.clamp(0, total);

                        return RefreshIndicator(
                          onRefresh: () => _refresh(context),
                          child: CustomScrollView(
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            slivers: [
                              SliverToBoxAdapter(child: _Header()),
                              const SliverToBoxAdapter(
                                  child: SizedBox(height: 12)),
                              SliverToBoxAdapter(
                                  child: _SearchField(l10n: l10n)),
                              const SliverToBoxAdapter(
                                  child: SizedBox(height: 12)),

                              // Loading state
                              if (state.loading) ...[
                                SliverPadding(
                                  padding: EdgeInsets.only(bottom: gridBottom),
                                  sliver: _GridSkeleton(
                                    maxCrossAxisExtent:
                                        gridConfig.maxCrossAxisExtent,
                                    childAspectRatio: gridConfig.aspect,
                                    crossAxisSpacing: gridConfig.spacing,
                                    mainAxisSpacing: gridConfig.spacing,
                                  ),
                                ),

                                // Error state
                              ] else if (state.error != null) ...[
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: _CenteredMessage(
                                    icon: Icons.error_outline_rounded,
                                    label: state.error!,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),

                                // Empty state
                              ] else if (total == 0) ...[
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: _EmptyProjects(l10n: l10n),
                                ),

                                // Data state
                              ] else ...[
                                // Grid of tiles (paged)
                                SliverPadding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  sliver: SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent:
                                          gridConfig.maxCrossAxisExtent,
                                      childAspectRatio: gridConfig.aspect,
                                      crossAxisSpacing: gridConfig.spacing,
                                      mainAxisSpacing: gridConfig.spacing,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final item = state.filtered[index];
                                        return ProjectTile(
                                          project: item,
                                          serverRootNoApi:
                                              _serverRootNoApi(widget.dio),
                                          onRebuild: (p) =>
                                              _rebuildAndRefresh(context, p),
                                        );
                                      },
                                      childCount: visible,
                                    ),
                                  ),
                                ),

                                // "Load more" button if we still have more data
                                if (visible < total)
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: gridBottom,
                                        top: 4,
                                      ),
                                      child: Center(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              _visibleCount =
                                                  (_visibleCount + _pageSize)
                                                      .clamp(0, total);
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.expand_more_rounded,
                                          ),
                                          label: Text(
                                            l10n.owner_projects_onlyReady
                                                    .isNotEmpty
                                                ? 'Load more'
                                                : 'Load more', // you can localize it later
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  SliverToBoxAdapter(
                                    child: SizedBox(height: gridBottom),
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
            },
          ),
        ),
      ),
    );
  }

  // ----- Responsive helpers -----

  double _maxContentWidth(double viewportWidth) {
    if (viewportWidth >= 1600) return 1400;
    if (viewportWidth >= 1400) return 1280;
    if (viewportWidth >= 1200) return 1100;
    return viewportWidth; // phones/tablets full width
  }

  double _contentHPad(double viewportWidth) {
    if (viewportWidth < 360) return 8;
    if (viewportWidth < 420) return 10;
    if (viewportWidth < 600) return 12;
    return 16;
  }

  _GridConf _gridConfig(double viewportWidth) {
    double maxCross;
    double aspect; // width / height
    double spacing;

    if (viewportWidth < 360) {
      maxCross = 220;
      aspect = 0.70; // taller tile
      spacing = 10;
    } else if (viewportWidth < 420) {
      maxCross = 240;
      aspect = 0.75;
      spacing = 10;
    } else if (viewportWidth < 520) {
      maxCross = 260;
      aspect = 0.80;
      spacing = 12;
    } else if (viewportWidth < 760) {
      maxCross = 280;
      aspect = 0.88;
      spacing = 12;
    } else if (viewportWidth < 1000) {
      maxCross = 310;
      aspect = 0.95;
      spacing = 12;
    } else if (viewportWidth < 1400) {
      maxCross = 330;
      aspect = 1.00;
      spacing = 14;
    } else {
      maxCross = 360;
      aspect = 1.05;
      spacing = 14;
    }

    return _GridConf(
      maxCrossAxisExtent: maxCross,
      aspect: aspect,
      spacing: spacing,
      bottomPad: 16,
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.owner_projects_title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.owner_projects_searchHint,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurface.withOpacity(.65),
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<OwnerProjectsBloc, OwnerProjectsState>(
            buildWhen: (p, c) => p.onlyReady != c.onlyReady,
            builder: (context, state) {
              return InkWell(
                onTap: () => context
                    .read<OwnerProjectsBloc>()
                    .add(const OwnerProjectsToggleOnlyReady()),
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
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w800,
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
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        onChanged: (v) => context
            .read<OwnerProjectsBloc>()
            .add(OwnerProjectsSearchChanged(v)),
        style: tt.bodyMedium,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: Icon(
            Icons.tune_rounded,
            color: cs.onSurface.withOpacity(.55),
          ),
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

  const _CenteredMessage({
    required this.icon,
    required this.label,
    this.color,
  });

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
            Text(
              label,
              textAlign: TextAlign.center,
              style: tt.bodyLarge?.copyWith(
                color: (color ?? cs.onSurface),
              ),
            ),
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
          Text(
            l10n.owner_projects_emptyTitle,
            textAlign: TextAlign.center,
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.owner_projects_emptyBody,
            textAlign: TextAlign.center,
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurface.withOpacity(.7),
            ),
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
  final double maxCrossAxisExtent;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const _GridSkeleton({
    required this.maxCrossAxisExtent,
    required this.childAspectRatio,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
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
    );
  }
}

class _GridConf {
  final double maxCrossAxisExtent;
  final double aspect;
  final double spacing;
  final double bottomPad;

  _GridConf({
    required this.maxCrossAxisExtent,
    required this.aspect,
    required this.spacing,
    required this.bottomPad,
  });
}
