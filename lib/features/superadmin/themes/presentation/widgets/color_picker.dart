import 'dart:ui';
import 'package:flutter/material.dart';

class AppColorPicker extends StatefulWidget {
  final Color initial;
  final bool showAlpha;

  const AppColorPicker({
    super.key,
    required this.initial,
    this.showAlpha = true,
  });

  @override
  State<AppColorPicker> createState() => _AppColorPickerState();

  static Future<Color?> show(
    BuildContext context, {
    required Color initial,
    bool showAlpha = true,
  }) {
    return showModalBottomSheet<Color>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ColorPickerSheet(initial: initial, showAlpha: showAlpha),
    );
  }
}

// ✅ ADD THIS
class _AppColorPickerState extends State<AppColorPicker> {
  @override
  Widget build(BuildContext context) {
    return _ColorPickerSheet(
      initial: widget.initial,
      showAlpha: widget.showAlpha,
    );
  }
}

class _ColorPickerSheet extends StatelessWidget {
  final Color initial;
  final bool showAlpha;

  const _ColorPickerSheet({required this.initial, required this.showAlpha});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: const [BoxShadow(blurRadius: 24, color: Colors.black26)],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetHandle(),
              const SizedBox(height: 8),
              _AppColorPickerCore(initial: initial, showAlpha: showAlpha),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 46,
        height: 5,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(999),
        ),
      );
}

class _AppColorPickerCore extends StatefulWidget {
  final Color initial;
  final bool showAlpha;

  const _AppColorPickerCore({required this.initial, required this.showAlpha});

  @override
  State<_AppColorPickerCore> createState() => _AppColorPickerCoreState();
}

class _AppColorPickerCoreState extends State<_AppColorPickerCore> {
  late HSVColor _hsv;
  late double _alpha;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.initial);
    _alpha = widget.initial.opacity;
  }

  Color get _color =>
      _hsv.toColor().withOpacity(widget.showAlpha ? _alpha : 1.0);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final swatches = <Color>[
      const Color(0xFF0BA360),
      const Color(0xFF0066CC),
      const Color(0xFF6C63FF),
      const Color(0xFFFF8F00),
      const Color(0xFFE53935),
      const Color(0xFF2E7D32),
      const Color(0xFF455A64),
      const Color(0xFF00B8D9),
      const Color(0xFFFFC107),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Preview
        Row(
          children: [
            _previewBox(_color, label: 'Light', bg: Colors.white),
            const SizedBox(width: 10),
            _previewBox(_color, label: 'Dark', bg: const Color(0xFF121212)),
          ],
        ),
        const SizedBox(height: 14),

        // Saturation/Value area
        AspectRatio(
          aspectRatio: 1.6,
          child: _SVPicker(
            hue: _hsv.hue,
            saturation: _hsv.saturation,
            value: _hsv.value,
            onChanged: (s, v) => setState(() {
              _hsv = _hsv.withSaturation(s).withValue(v);
            }),
          ),
        ),
        const SizedBox(height: 12),

        // Hue
        _LabeledSlider(
          label: 'Hue',
          child: Slider(
            value: _hsv.hue,
            min: 0,
            max: 360,
            onChanged: (v) => setState(() => _hsv = _hsv.withHue(v)),
          ),
        ),

        if (widget.showAlpha) ...[
          const SizedBox(height: 8),
          _LabeledSlider(
            label: 'Alpha',
            child: Slider(
              value: _alpha,
              min: 0,
              max: 1,
              onChanged: (v) => setState(() => _alpha = v),
            ),
          ),
        ],

        const SizedBox(height: 6),
        // Quick swatches
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in swatches)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _hsv = HSVColor.fromColor(c);
                      _alpha = 1;
                    });
                  },
                  child: _swatch(c),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Text(
              '#${_color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, _color),
              icon: const Icon(Icons.check),
              label: const Text('OK'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _previewBox(Color c, {required String label, required Color bg}) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Center(
          child: Container(
            width: 110,
            height: 30,
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: _onColor(c),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _onColor(Color c) {
    final luminance = c.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
    // simple contrast heuristic
  }

  Widget _swatch(Color c) => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
      );
}

/// Labeled slider wrapper for a clean look
class _LabeledSlider extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledSlider({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label)),
        Expanded(child: child),
      ],
    );
  }
}

/// Saturation/Value 2D picker for a fixed hue.
class _SVPicker extends StatefulWidget {
  final double hue; // 0..360
  final double saturation; // 0..1
  final double value; // 0..1
  final void Function(double s, double v) onChanged;

  const _SVPicker({
    required this.hue,
    required this.saturation,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_SVPicker> createState() => _SVPickerState();
}

class _SVPickerState extends State<_SVPicker> {
  late double s = widget.saturation;
  late double v = widget.value;

  @override
  void didUpdateWidget(covariant _SVPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // keep S/V when hue changes from outside
    s = widget.saturation;
    v = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, c) {
      final w = c.maxWidth;
      final h = c.maxHeight;

      void update(Offset localPos) {
        final dx = localPos.dx.clamp(0, w);
        final dy = localPos.dy.clamp(0, h);
        final ns = (dx / w).clamp(0.0, 1.0);
        final nv = (1 - dy / h).clamp(0.0, 1.0);
        setState(() {
          s = ns;
          v = nv;
        });
        widget.onChanged(ns, nv);
      }

      return GestureDetector(
        onPanDown: (d) => update(d.localPosition),
        onPanUpdate: (d) => update(d.localPosition),
        child: CustomPaint(
          painter: _SVPainter(widget.hue),
          child: Stack(
            children: [
              Positioned(
                left: s * w - 10,
                top: (1 - v) * h - 10,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _SVPainter extends CustomPainter {
  final double hue;
  _SVPainter(this.hue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Horizontal: saturation (0 → white, 1 → hue color)
    final left = HSVColor.fromAHSV(1, hue, 0, 1).toColor();
    final right = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
    paint.shader = LinearGradient(
      colors: [left, right],
    ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);

    // Vertical: value (top 100% → bottom 0% black)
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.black],
    ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);

    // Border
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black12;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(8)),
      border,
    );
  }

  @override
  bool shouldRepaint(covariant _SVPainter oldDelegate) =>
      oldDelegate.hue != hue;
}
