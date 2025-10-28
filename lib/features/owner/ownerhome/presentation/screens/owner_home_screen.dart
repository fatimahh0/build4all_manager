import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';

import '../../../common/data/repositories/owner_repository_impl.dart';
import '../../../common/data/services/owner_api.dart';
import '../../../common/domain/usecases/get_app_config_uc.dart';
import '../../../common/domain/usecases/get_my_apps_uc.dart';
import '../../../common/domain/usecases/get_my_requests_uc.dart';

import '../bloc/owner_home_bloc.dart';
import '../bloc/owner_home_event.dart';
import '../bloc/owner_home_state.dart';
import '../widgets/home_header.dart';
import '../widgets/project_chip.dart';
import '../widgets/request_row.dart';
import '../widgets/howto_carousel.dart';

class OwnerHomeScreen extends StatelessWidget {
  final int ownerId;
  final Dio dio;
  const OwnerHomeScreen({super.key, required this.ownerId, required this.dio});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    final repo = OwnerRepositoryImpl(OwnerApi(dio));
    final bloc = OwnerHomeBloc(
      getMyApps: GetMyAppsUc(repo),
      getMyRequests: GetMyRequestsUc(repo),
      getAppConfig: GetAppConfigUc(repo),
    )..add(OwnerHomeStarted(ownerId));

    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        backgroundColor: cs.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<OwnerHomeBloc, OwnerHomeState>(
              builder: (context, state) {
                final hasProjects = state.apps.isNotEmpty;
                final hasRequests = state.recent.isNotEmpty;
                final isEmpty = !hasProjects && !hasRequests;

                return RefreshIndicator(
                  onRefresh: () async => context
                      .read<OwnerHomeBloc>()
                      .add(OwnerHomeRefreshed(ownerId)),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      const SliverToBoxAdapter(child: HomeHeader()),
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),

                      // CTA
                      SliverToBoxAdapter(
                        child: _PrimaryCta(
                          label: l10n.owner_home_requestApp,
                          onPressed: () => Navigator.of(context)
                              .pushNamed('/owner/request-new'),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),

                      // Empty State (How-To) — shown only when no projects & no requests
                      SliverToBoxAdapter(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 280),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: (!state.loading && isEmpty)
                              ? HowToCarousel(
                                  pages: [
                                    HowToPage(
                                      emoji: '📦',
                                      title: l10n.tutorial_step1_title,
                                      subtitle: l10n.tutorial_step1_body,
                                      actionLabel: l10n.owner_home_requestApp,
                                      onAction: () => Navigator.of(context)
                                          .pushNamed('/owner/request-new'),
                                    ),
                                    HowToPage(
                                      emoji: '🧾',
                                      title: l10n.tutorial_step2_title,
                                      subtitle: l10n.tutorial_step2_body,
                                    ),
                                    HowToPage(
                                      emoji: '⬇️',
                                      title: l10n.tutorial_step3_title,
                                      subtitle: l10n.tutorial_step3_body,
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),

                      // Projects (hide title when empty)
                      if (state.loading && !hasProjects)
                        const SliverToBoxAdapter(
                          child: _HorizontalSkeleton(height: 86),
                        )
                      else if (hasProjects) ...[
                        SliverToBoxAdapter(
                          child: Text(
                            l10n.owner_home_myProjects,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 12)),
                        SliverToBoxAdapter(
                          child: _FadeIn(
                            child: SizedBox(
                              height: 86,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.apps.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (_, i) => ProjectChip(
                                  project: state.apps[i],
                                  onTap: () => Navigator.of(context)
                                      .pushNamed('/owner/projects'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      ],

                      // Recent Requests (hide title when empty)
                      if (state.loading && !hasRequests)
                        const SliverToBoxAdapter(
                          child: _ListSkeleton(itemCount: 2),
                        )
                      else if (hasRequests) ...[
                        SliverToBoxAdapter(
                          child: Text(
                            l10n.owner_home_recentRequests,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 8)),
                        SliverList.builder(
                          itemCount: state.recent.length,
                          itemBuilder: (_, i) => _FadeIn(
                            delay: 80 * i,
                            child: RequestRow(request: state.recent[i]),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 8)),
                        SliverToBoxAdapter(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed('/owner/requests'),
                              child: Text(l10n.owner_home_viewAll),
                            ),
                          ),
                        ),
                      ],

                      const SliverToBoxAdapter(child: SizedBox(height: 8)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// local UI helpers
class _PrimaryCta extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _PrimaryCta({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .96, end: 1),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutBack,
      builder: (context, s, child) => Transform.scale(scale: s, child: child),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt_rounded),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _FadeIn extends StatelessWidget {
  final Widget child;
  final int delay; // ms
  const _FadeIn({required this.child, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (context, v, c) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, (1 - v) * 12), child: c),
      ),
      child: child,
    );
  }
}

class _HorizontalSkeleton extends StatelessWidget {
  final double height;
  const _HorizontalSkeleton({this.height = 86});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => Container(
          width: 160,
          decoration: BoxDecoration(
            color: cs.surfaceVariant.withOpacity(.5),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  final int itemCount;
  const _ListSkeleton({this.itemCount = 2});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: List.generate(itemCount, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 44,
          decoration: BoxDecoration(
            color: cs.surfaceVariant.withOpacity(.5),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}
