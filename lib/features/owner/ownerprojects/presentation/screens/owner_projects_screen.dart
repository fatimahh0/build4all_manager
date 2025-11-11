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
  const OwnerProjectsScreen(
      {super.key, required this.ownerId, required this.dio});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final repo = OwnerRepositoryImpl(OwnerApi(dio));

    String _serverRootNoApi(Dio d) {
      final base = d.options.baseUrl; // e.g. http://192.168.1.3:8080/api
      return base.replaceFirst(
          RegExp(r'/api/?$'), ''); // -> http://192.168.1.3:8080
    }

    Future<void> _refresh(BuildContext ctx) async {
      // Re-trigger your initial load
      ctx.read<OwnerProjectsBloc>().add(OwnerProjectsStarted(ownerId));
      // Optional tiny delay so the indicator doesn’t instantly snap back
      await Future.delayed(const Duration(milliseconds: 400));
    }

    return BlocProvider(
      create: (_) => OwnerProjectsBloc(getMyApps: GetMyAppsUc(repo))
        ..add(OwnerProjectsStarted(ownerId)),
      child: Scaffold(
        backgroundColor: cs.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Title + filters
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.owner_projects_title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    _OnlyReadySwitch(l10n: l10n),
                  ],
                ),
                const SizedBox(height: 12),
                _SearchField(l10n: l10n),
                const SizedBox(height: 12),

                // === MAIN AREA WITH REFRESH INDICATOR ===
                Expanded(
                  child: BlocBuilder<OwnerProjectsBloc, OwnerProjectsState>(
                    builder: (context, state) {
                      // Wrap *every* branch in a RefreshIndicator + an always-scrollable child
                      return RefreshIndicator(
                        onRefresh: () => _refresh(context),
                        child: _buildScrollableBody(
                          context: context,
                          state: state,
                          l10n: l10n,
                          cs: cs,
                          serverRootNoApi: _serverRootNoApi(dio),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Ensures pull-to-refresh works even when the UI isn't naturally scrollable
  Widget _buildScrollableBody({
    required BuildContext context,
    required OwnerProjectsState state,
    required AppLocalizations l10n,
    required ColorScheme cs,
    required String serverRootNoApi,
  }) {
    if (state.loading) {
      // Make the skeleton scrollable so the indicator can appear
      return const _GridSkeleton(alwaysScrollable: true);
    }

    if (state.error != null) {
      // Wrap error UI with a SingleChildScrollView + AlwaysScrollable
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .6,
          child: Center(
            child: Text(state.error!, style: TextStyle(color: cs.error)),
          ),
        ),
      );
    }

    final items = state.filtered;
    if (items.isEmpty) {
      // Same trick for empty UI
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .6,
          child: _EmptyProjects(l10n: l10n),
        ),
      );
    }

    // Normal grid with AlwaysScrollable so pull works at top as well
    return GridView.builder(
      padding: const EdgeInsets.only(top: 4),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.28,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => ProjectTile(
        project: items[i],
        serverRootNoApi: serverRootNoApi,
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final AppLocalizations l10n;
  const _SearchField({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (v) =>
          context.read<OwnerProjectsBloc>().add(OwnerProjectsSearchChanged(v)),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: l10n.owner_projects_searchHint,
      ),
    );
  }
}

class _OnlyReadySwitch extends StatelessWidget {
  final AppLocalizations l10n;
  const _OnlyReadySwitch({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerProjectsBloc, OwnerProjectsState>(
      buildWhen: (p, c) => p.onlyReady != c.onlyReady,
      builder: (context, state) {
        return Row(
          children: [
            Text(l10n.owner_projects_onlyReady,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: 6),
            Switch(
              value: state.onlyReady,
              onChanged: (_) => context
                  .read<OwnerProjectsBloc>()
                  .add(const OwnerProjectsToggleOnlyReady()),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  final AppLocalizations l10n;
  const _EmptyProjects({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.widgets_outlined, size: 56, color: cs.outline),
        const SizedBox(height: 10),
        Text(
          l10n.owner_projects_emptyTitle,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.owner_projects_emptyBody,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: cs.onSurface.withOpacity(.7)),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () =>
              Navigator.of(context).pushNamed('/owner/request-new'),
          icon: const Icon(Icons.bolt_rounded),
          label: Text(l10n.owner_home_requestApp),
        ),
      ],
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  final bool alwaysScrollable;
  const _GridSkeleton({this.alwaysScrollable = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final grid = GridView.builder(
      padding: EdgeInsets.zero,
      physics: alwaysScrollable ? const AlwaysScrollableScrollPhysics() : null,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.28,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: cs.surfaceVariant.withOpacity(.5),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );

    return grid;
  }
}
