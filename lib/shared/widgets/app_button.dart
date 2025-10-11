import 'package:flutter/material.dart';

enum AppButtonSize { sm, md, lg }

enum AppButtonVariant { filled, tonal, outline }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final AppButtonSize size;
  final AppButtonVariant variant;
  final IconData? leading;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
    this.size = AppButtonSize.lg,
    this.variant = AppButtonVariant.filled,
    this.leading,
    this.fullWidth = true,
  });

  EdgeInsets get _pad => switch (size) {
        AppButtonSize.sm =>
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        AppButtonSize.md =>
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        AppButtonSize.lg =>
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      };

  double get _font => switch (size) {
        AppButtonSize.sm => 14,
        AppButtonSize.md => 15,
        AppButtonSize.lg => 16,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));

    Widget child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[
          Icon(leading, size: _font + 2),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: loading
                ? SizedBox(
                    key: const ValueKey('spinner'),
                    height: _font + 2,
                    width: _font + 2,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    key: const ValueKey('text'),
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: _font),
                  ),
          ),
        ),
      ],
    );

    switch (variant) {
      case AppButtonVariant.filled:
        child = ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: _pad,
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            shape: shape,
            elevation: 0,
          ),
          child: child,
        );
        break;
      case AppButtonVariant.tonal:
        child = FilledButton(
          onPressed: loading ? null : onPressed,
          style: FilledButton.styleFrom(
            padding: _pad,
            backgroundColor: cs.secondaryContainer,
            foregroundColor: cs.onSecondaryContainer,
            shape: shape,
            elevation: 0,
          ),
          child: child,
        );
        break;
      case AppButtonVariant.outline:
        child = OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: _pad,
            shape: shape,
            side: BorderSide(color: cs.primary),
            foregroundColor: cs.primary,
          ),
          child: child,
        );
        break;
    }

    return fullWidth ? SizedBox(width: double.infinity, child: child) : child;
  }
}
