import 'package:flutter/material.dart';
import 'color_picker.dart';

class ColorField extends StatefulWidget {
  final String label;
  final Color? initial;
  final ValueChanged<Color?> onChanged;
  final bool showAlpha;

  const ColorField({
    super.key,
    required this.label,
    required this.initial,
    required this.onChanged,
    this.showAlpha = true,
  });

  @override
  State<ColorField> createState() => _ColorFieldState();
}

class _ColorFieldState extends State<ColorField> {
  Color? _c;

  @override
  void initState() {
    super.initState();
    _c = widget.initial;
  }

  @override
  void didUpdateWidget(covariant ColorField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initial != widget.initial) _c = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final preview = _c ?? cs.surfaceContainerHighest;

    return InkWell(
      onTap: () async {
        final picked = await AppColorPicker.show(
          context,
          initial: _c ?? cs.primary,
          showAlpha: widget.showAlpha,
        );
        if (picked != null) {
          setState(() => _c = picked);
          widget.onChanged(picked);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: preview,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: cs.outlineVariant),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.label,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              _c == null
                  ? '—'
                  : '#${_c!.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
