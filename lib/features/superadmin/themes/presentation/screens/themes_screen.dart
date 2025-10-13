import 'package:build4all_manager/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';
import '../widgets/theme_card.dart';
import '../widgets/theme_editor_sheet.dart';
import '../../domain/entities/theme_entity.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<ThemeBloc, ThemeState>(
      listenWhen: (p, c) => p.error != c.error,
      listener: (ctx, st) {
        if (st.error != null && st.error!.isNotEmpty) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(st.error!),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final cs = Theme.of(context).colorScheme;

        // Outer FAB shown only on compact layouts (see LayoutBuilder below)
        bool showFab = false;

        final body = LayoutBuilder(
          builder: (ctx, c) {
            final w = c.maxWidth;
            final isCompact = w < 520;
            showFab = isCompact;

            // responsive actions
            List<Widget> _appBarActions() {
              if (!isCompact) {
                return [
                  TextButton.icon(
                    onPressed: state.loading
                        ? null
                        : () => context
                            .read<ThemeBloc>()
                            .add(DeactivateAllThemesEvent()),
                    icon: const Icon(Icons.power_settings_new_rounded),
                    label: Text(l10n.themes_deactivate_all),
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilledButton.icon(
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l10n.themes_add),
                      onPressed: () => _openCreate(context),
                    ),
                  ),
                ];
              }

              // overflow menu on small widths
              return [
                PopupMenuButton<String>(
                  tooltip: l10n.common_more,
                  onSelected: (key) {
                    switch (key) {
                      case 'deactivate':
                        if (!state.loading) {
                          context
                              .read<ThemeBloc>()
                              .add(DeactivateAllThemesEvent());
                        }
                        break;
                      case 'create':
                        _openCreate(context);
                        break;
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'create',
                      child: Row(
                        children: [
                          const Icon(Icons.add_rounded),
                          const SizedBox(width: 8),
                          Text(l10n.themes_add),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'deactivate',
                      child: Row(
                        children: [
                          const Icon(Icons.power_settings_new_rounded),
                          const SizedBox(width: 8),
                          Text(l10n.themes_deactivate_all),
                        ],
                      ),
                    ),
                  ],
                ),
              ];
            }

            // responsive columns
            int cols;
            if (w >= 1280) {
              cols = 4;
            } else if (w >= 980) {
              cols = 3;
            } else if (w >= 640) {
              cols = 2;
            } else {
              cols = 1;
            }

            // card height scales slightly with textScale to avoid overflow
            final ts = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);
            final cardHeight = (220 * ts).clamp(208.0, 260.0);

            return RefreshIndicator.adaptive(
              onRefresh: () async =>
                  context.read<ThemeBloc>().add(RefreshThemes()),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    stretch: true,
                    expandedHeight: 96,
                    title: Text(l10n.themes_title),
                    actions: _appBarActions(),
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                      ],
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              cs.primary.withOpacity(.06),
                              cs.secondary.withOpacity(.04),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // inline error banner (non-blocking)
                  if (state.error != null && state.error!.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Material(
                          color: cs.error.withOpacity(.08),
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            leading: Icon(Icons.error_outline, color: cs.error),
                            title: Text(
                              state.error!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: cs.error),
                            ),
                            trailing: TextButton(
                              onPressed: () =>
                                  context.read<ThemeBloc>().add(LoadThemes()),
                              child: Text(l10n.common_retry),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // loading
                  if (state.loading && state.items.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  // empty
                  else if (state.items.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.palette_outlined,
                                size: 46, color: cs.onSurfaceVariant),
                            const SizedBox(height: 12),
                            Text(
                              l10n.themes_empty,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: cs.onSurfaceVariant),
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              icon: const Icon(Icons.add_rounded),
                              label: Text(l10n.themes_add),
                              onPressed: () => _openCreate(context),
                            ),
                          ],
                        ),
                      ),
                    )
                  // grid
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) {
                            final ThemeEntity t = state.items[i];
                            return ThemeCard(
                              themeItem: t,
                              onSetActive: () => context
                                  .read<ThemeBloc>()
                                  .add(SetActiveThemeEvent(t.id)),
                              onEdit: () => _openEdit(context, t),
                              onDelete: () => _confirmDelete(context, t.id),
                              onMenuTypeChanged: (menu) => context
                                  .read<ThemeBloc>()
                                  .add(SetMenuTypeEvent(t.id, menu)),
                            );
                          },
                          childCount: state.items.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          mainAxisExtent: cardHeight,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                ],
              ),
            );
          },
        );

        // Scaffold-level FAB for compact layouts to avoid action overflow
        return Scaffold(
          body: SafeArea(top: false, child: body),
          floatingActionButton: showFab
              ? FloatingActionButton.extended(
                  onPressed: () => _openCreate(context),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l10n.themes_add),
                )
              : null,
        );
      },
    );
  }

  Future<void> _openCreate(BuildContext context) async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ThemeEditorSheet(
        onSubmit: (body) =>
            context.read<ThemeBloc>().add(CreateThemeEvent(body)),
      ),
    );
    if (ok == true) {
      // ignore: use_build_context_synchronously
      context.read<ThemeBloc>().add(LoadThemes());
    }
  }

  Future<void> _openEdit(BuildContext context, ThemeEntity t) async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ThemeEditorSheet(
        themeItem: t,
        onSubmit: (body) =>
            context.read<ThemeBloc>().add(UpdateThemeEvent(t.id, body)),
      ),
    );
    if (ok == true) {
      // ignore: use_build_context_synchronously
      context.read<ThemeBloc>().add(LoadThemes());
    }
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.common_delete),
        content: Text(l10n.themes_confirm_delete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
    if (ok == true) {
      // ignore: use_build_context_synchronously
      context.read<ThemeBloc>().add(DeleteThemeEvent(id));
    }
  }
}
