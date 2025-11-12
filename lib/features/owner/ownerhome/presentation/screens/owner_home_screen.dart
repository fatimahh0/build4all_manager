// lib/features/owner/ownerhome/presentation/screens/owner_home_screen.dart
import 'package:build4all_manager/shared/themes/app_theme.dart'; // for UiTokens extension
import 'package:build4all_manager/shared/widgets/search_input.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../common/data/repositories/owner_repository_impl.dart';
import '../../../common/data/services/owner_api.dart';
import '../../../common/domain/usecases/get_app_config_uc.dart';
import '../../../common/domain/usecases/get_my_requests_uc.dart';

import '../bloc/owner_home_bloc.dart';
import '../bloc/owner_home_event.dart';
import '../bloc/owner_home_state.dart';

import '../widgets/request_card.dart';
import '../../data/static_project_models.dart';
import '../widgets/project_template_card.dart';

class OwnerHomeScreen extends StatelessWidget {
  final int ownerId;
  final Dio dio;
  const OwnerHomeScreen({super.key, required this.ownerId, required this.dio});

  @override
  Widget build(BuildContext context) {
    final repo = OwnerRepositoryImpl(OwnerApi(dio));
    return BlocProvider(
      create: (_) => OwnerHomeBloc(
        getMyRequests: GetMyRequestsUc(repo),
        getAppConfig: GetAppConfigUc(repo),
      )..add(OwnerHomeStarted(ownerId)),
      child: const _HomeScaffold(),
    );
  }
}

class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.background,
      body: const SafeArea(child: _HomeBody()),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final ux = Theme.of(context).extension<UiTokens>()!;

    // Responsive outer padding
    final w = MediaQuery.of(context).size.width;
    final pagePad = w >= 480
        ? const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
        : ux.pagePad;

    return Padding(
      padding: pagePad,
      child: BlocBuilder<OwnerHomeBloc, OwnerHomeState>(
        builder: (context, state) {
          final ownerId =
              (context.findAncestorWidgetOfExactType<OwnerHomeScreen>()!)
                  .ownerId;

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<OwnerHomeBloc>().add(OwnerHomeRefreshed(ownerId)),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                // ---------- Header ----------
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'OWNER HUB',
                              style: tt.labelSmall?.copyWith(
                                letterSpacing: 1.2,
                                color: cs.onSurface.withOpacity(.55),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.owner_home_hello,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: tt.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: w >= 420 ? 22 : 20,
                                  backgroundColor: cs.primary,
                                  child: const Icon(Icons.person,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.owner_home_subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: tt.bodyMedium?.copyWith(
                                color: cs.onSurface.withOpacity(.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // ---------- Shared Search ----------
                const SliverToBoxAdapter(
                  child: AppSearchInput(hintKey: 'owner_home_search_hint'),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // ---------- Choose your project (SINGLE grid, responsive) ----------
                SliverToBoxAdapter(
                  child: Text(
                    l10n.owner_home_chooseProject,
                    style:
                        tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // One responsive grid (no duplicates, no overflow)
                SliverPadding(
                  padding: EdgeInsets.only(bottom: ux.radiusMd),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final cross = constraints.crossAxisExtent;

                      // Taller tiles on tiny screens so text+button always fit
                      final aspect = cross < 340
                          ? 0.78 // very small phones
                          : (cross < 420)
                              ? 0.90 // small/medium phones
                              : 1.02; // large phones / tablets

                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 260, // auto columns
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: aspect,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final tpl = projectTemplates[i];
                            return ProjectTemplateCard(
                              tpl: tpl,
                              onOpen: () =>
                                  context.push('/owner/project/${tpl.id}'),
                            );
                          },
                          childCount: projectTemplates.length,
                        ),
                      );
                    },
                  ),
                ),

                // ---------- Recent requests ----------
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.owner_home_recentRequests,
                          style: tt.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/owner/requests'),
                        child: Text(l10n.owner_home_viewAll),
                      ),
                    ],
                  ),
                ),

                if (state.loading && state.recent.isEmpty)
                  const SliverToBoxAdapter(child: _LoadingList())
                else if (state.recent.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 12),
                      child: Text(
                        l10n.owner_home_noRecent,
                        style: tt.bodyMedium
                            ?.copyWith(color: cs.onSurface.withOpacity(.7)),
                      ),
                    ),
                  )
                else
                  SliverList.builder(
                    itemCount: state.recent.length,
                    itemBuilder: (_, i) => RequestCard(req: state.recent[i]),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: List.generate(3, (i) {
        return Container(
          height: 64,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: cs.surfaceVariant.withOpacity(.45),
            borderRadius: BorderRadius.circular(14),
          ),
        );
      }),
    );
  }
}
