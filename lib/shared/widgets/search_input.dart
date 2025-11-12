// lib/shared/widgets/search_input.dart
import 'package:flutter/material.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';

class AppSearchInput extends StatelessWidget {
  final String? hintKey; // e.g. 'owner_home_search_hint'
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool dense;

  const AppSearchInput({
    super.key,
    this.hintKey,
    this.onChanged,
    this.onTap,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final hint = switch (hintKey) {
      'owner_home_search_hint' => l10n.owner_home_search_hint,
      _ => l10n.owner_home_search_hint,
    };

    return TextField(
      onChanged: onChanged,
      readOnly: onTap != null,
      onTap: onTap,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon:
            Icon(Icons.tune_rounded, color: cs.onSurface.withOpacity(.55)),
        hintText: hint,
        filled: true,
        fillColor: cs.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: dense ? 10 : 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
      ),
    );
  }
}
