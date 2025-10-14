// lib/presentation/widgets/theme_card.dart
import 'package:build4all_manager/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/theme_entity.dart';

class ThemeCard extends StatelessWidget {
  final ThemeEntity themeItem;
  final VoidCallback onSetActive;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<String> onMenuTypeChanged;

  const ThemeCard({
    super.key,
    required this.themeItem,
    required this.onSetActive,
    required this.onEdit,
    required this.onDelete,
    required this.onMenuTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (ctx, c) {
        final w = c.maxWidth;
        final tight = w < 380; // very small card width
        final compact = w < 520; // small-ish card width

        return Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // <-- avoid claiming extra height
              children: [
                // Header
                Row(
                  children: [
                    _swatch(themeItem.primary, themeItem.secondary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        themeItem.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    if (themeItem.active)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primary.withOpacity(.12),
                          border:
                              Border.all(color: cs.primary.withOpacity(.25)),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l10n.themes_active,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // Color chips (already wrap-safe)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chipColor(context, 'Primary', themeItem.primary),
                    _chipColor(context, 'Secondary', themeItem.secondary),
                    _chipColor(context, 'Success', themeItem.success),
                    _chipColor(context, 'Warning', themeItem.warning),
                    _chipColor(context, 'Error', themeItem.error),
                  ],
                ),

                const SizedBox(height: 12), // <-- replaces Spacer()

                // Controls (overflow-proof)
                if (tight) ...[
                  _MenuTypePicker(
                    value: (themeItem.menuType).toLowerCase(),
                    onChanged: onMenuTypeChanged,
                  ),
                  const SizedBox(height: 8),
                  _ActionsOverflowBar(
                    onEdit: onEdit,
                    onDelete: onDelete,
                    onSetActive: onSetActive,
                    dense: true,
                  ),
                ] else ...[
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _MenuTypePicker(
                          value: (themeItem.menuType).toLowerCase(),
                          onChanged: onMenuTypeChanged,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ActionsOverflowBar(
                    onEdit: onEdit,
                    onDelete: onDelete,
                    onSetActive: onSetActive,
                    dense: compact,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _swatch(int? p, int? s) {
    final pc = p == null ? const Color(0xFF888888) : Color(p);
    final sc = s == null ? const Color(0xFFBBBBBB) : Color(s);
    return SizedBox(
      width: 54,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: [pc, sc]),
        ),
      ),
    );
  }

  Widget _chipColor(BuildContext context, String label, int? hex) {
    final cs = Theme.of(context).colorScheme;
    final c = hex == null ? cs.outline : Color(hex);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(.25)),
        color: c.withOpacity(.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: c, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ActionsOverflowBar extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetActive;
  final bool dense;

  const _ActionsOverflowBar({
    required this.onEdit,
    required this.onDelete,
    required this.onSetActive,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final gap = dense ? 6.0 : 8.0;

    return OverflowBar(
      alignment: MainAxisAlignment.end,
      spacing: gap,
      overflowSpacing: gap,
      children: [
        IconButton(
          tooltip: 'Delete',
          onPressed: onDelete,
          icon: Icon(Icons.delete_outline, color: cs.error),
        ),
        FilledButton.icon(
          onPressed: onSetActive,
          icon: const Icon(Icons.check_circle_rounded, size: 20),
          label: const Text('Set active'),
        ),
      ],
    );
  }
}

class _MenuTypePicker extends StatelessWidget {
  final String value; // top | bottom | drawer
  final ValueChanged<String> onChanged;
  const _MenuTypePicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final opts = const ['bottom', 'top', 'drawer'];
    // let it size to content without forcing overflow
    return IntrinsicWidth(
      child: SegmentedButton<String>(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? cs.primary.withOpacity(.10)
                : null,
          ),
        ),
        segments: const [
          ButtonSegment(
              value: 'bottom',
              icon: Icon(Icons.space_bar),
              label: Text('Bottom')),
          ButtonSegment(
              value: 'top', icon: Icon(Icons.drag_handle), label: Text('Top')),
          ButtonSegment(
              value: 'drawer', icon: Icon(Icons.menu), label: Text('Drawer')),
        ],
        selected: {opts.contains(value) ? value : 'bottom'},
        onSelectionChanged: (set) => onChanged(set.first),
      ),
    );
  }
}
