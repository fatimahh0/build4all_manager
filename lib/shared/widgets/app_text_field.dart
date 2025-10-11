import 'package:flutter/material.dart';
import 'package:build4all_manager/l10n/app_localizations.dart'; // ⬅️ use your generated l10n

/// A polished, theme-aware text input built on TextFormField
/// - supports prefix/suffix icons
/// - built-in clear / eye toggle
/// - error + helper text
/// - dense paddings that adapt to screen size
class AppTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? helper;
  final String? initialError; // show an initial error (if any)
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final bool enabled;
  final bool autofocus;
  final bool obscure; // if true -> shows an eye toggle
  final int? maxLines; // defaults to 1 if obscure
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;

  const AppTextInput({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.helper,
    this.initialError,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.enabled = true,
    this.autofocus = false,
    this.obscure = false,
    this.maxLines,
    this.onSubmitted,
    this.onChanged,
  });

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  late bool _obscure = widget.obscure;
  String? _error;

  @override
  void initState() {
    super.initState();
    _error = widget.initialError;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context)!; // ⬅️ your strings

    // safer fill across Flutter versions
    final fill = cs.surfaceVariant.withOpacity(
      theme.brightness == Brightness.dark ? .18 : .5,
    );

    // adaptive content padding
    final width = MediaQuery.of(context).size.width;
    final pad = EdgeInsets.symmetric(
      horizontal: width >= 1000 ? 18 : 14,
      vertical: width >= 1000 ? 16 : 14,
    );

    final isObscurable = widget.obscure;
    final isEmpty = widget.controller.text.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (_) => setState(() {}), // refresh suffix visibility
          child: TextFormField(
            controller: widget.controller,
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: _obscure,
            maxLines: isObscurable ? 1 : (widget.maxLines ?? 1),
            validator: (v) {
              final err = widget.validator?.call(v);
              setState(() => _error = err);
              return err;
            },
            onChanged: (v) {
              if (_error != null) setState(() => _error = null);
              widget.onChanged?.call(v);
            },
            onFieldSubmitted: widget.onSubmitted,
            decoration: InputDecoration(
              hintText: widget.hint,
              helperText: widget.helper,
              errorText: _error,
              filled: true,
              fillColor: fill,
              contentPadding: pad,
              prefixIcon: widget.prefixIcon == null
                  ? null
                  : Icon(widget.prefixIcon, color: cs.primary),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isObscurable && !isEmpty)
                    IconButton(
                      // OPTIONAL: add this key to ARB: "clearTextField": "Clear text"
                      tooltip: /* t.clearTextField */
                          MaterialLocalizations.of(context).deleteButtonTooltip,
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        widget.controller.clear();
                        widget.onChanged?.call('');
                        setState(() {}); // refresh to hide clear btn
                      },
                    ),
                  if (isObscurable)
                    IconButton(
                      tooltip: _obscure
                          ? t.showPasswordLabel
                          : t.hidePasswordLabel, // ⬅️ use your l10n keys
                      icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                ],
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: cs.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: cs.primary, width: 1.6),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: cs.error),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
