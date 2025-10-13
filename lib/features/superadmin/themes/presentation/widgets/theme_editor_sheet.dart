import 'package:build4all_manager/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/theme_entity.dart';
import 'color_field.dart';

typedef SubmitThemeBody = void Function(Map<String, dynamic> body);

class ThemeEditorSheet extends StatefulWidget {
  final ThemeEntity? themeItem;
  final SubmitThemeBody? onSubmit;

  const ThemeEditorSheet({super.key, this.themeItem, this.onSubmit});

  @override
  State<ThemeEditorSheet> createState() => _ThemeEditorSheetState();
}

class _ThemeEditorSheetState extends State<ThemeEditorSheet> {
  final _form = GlobalKey<FormState>();
  final name = TextEditingController();
  final menuType = ValueNotifier<String>('bottom');

  Color? cPrimary, cSecondary, cSuccess, cWarning, cError;

  @override
  void initState() {
    super.initState();
    final t = widget.themeItem;
    if (t != null) {
      name.text = t.name;
      menuType.value = t.menuType.toLowerCase();
      cPrimary = t.primary == null ? null : Color(t.primary!);
      cSecondary = t.secondary == null ? null : Color(t.secondary!);
      cSuccess = t.success == null ? null : Color(t.success!);
      cWarning = t.warning == null ? null : Color(t.warning!);
      cError = t.error == null ? null : Color(t.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final inset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: inset),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: const [BoxShadow(blurRadius: 24, color: Colors.black26)],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Form(
              key: _form,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.themeItem == null
                            ? l10n.themes_add
                            : l10n.common_edit,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context, false),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                        labelText: l10n.themes_name, hintText: 'Emerald'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.err_required
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.themes_menuType),
                  const SizedBox(height: 6),
                  ValueListenableBuilder<String>(
                    valueListenable: menuType,
                    builder: (_, val, __) => SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                            value: 'bottom',
                            icon: Icon(Icons.space_bar),
                            label: Text('Bottom')),
                        ButtonSegment(
                            value: 'top',
                            icon: Icon(Icons.drag_handle),
                            label: Text('Top')),
                        ButtonSegment(
                            value: 'drawer',
                            icon: Icon(Icons.menu),
                            label: Text('Drawer')),
                      ],
                      selected: {val},
                      onSelectionChanged: (s) => menuType.value = s.first,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(l10n.themes_colors_section,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),

                  // Visual color fields
                  ColorField(
                    label: 'Primary',
                    initial: cPrimary,
                    onChanged: (c) => cPrimary = c,
                  ),
                  const SizedBox(height: 10),
                  ColorField(
                    label: 'Secondary',
                    initial: cSecondary,
                    onChanged: (c) => cSecondary = c,
                  ),
                  const SizedBox(height: 10),
                  ColorField(
                    label: 'Success',
                    initial: cSuccess,
                    onChanged: (c) => cSuccess = c,
                  ),
                  const SizedBox(height: 10),
                  ColorField(
                    label: 'Warning',
                    initial: cWarning,
                    onChanged: (c) => cWarning = c,
                  ),
                  const SizedBox(height: 10),
                  ColorField(
                    label: 'Error',
                    initial: cError,
                    onChanged: (c) => cError = c,
                  ),
                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.save_rounded),
                      label: Text(l10n.common_save),
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;

    final body = <String, dynamic>{
      'name': name.text.trim(),
      'menuType': menuType.value,
    };

    void put(String key, Color? c) {
      if (c != null) body[key] = c.value; // ARGB int for the backend
    }

    put('primary', cPrimary);
    put('secondary', cSecondary);
    put('success', cSuccess);
    put('warning', cWarning);
    put('error', cError);

    widget.onSubmit?.call(body);
    Navigator.pop(context, true);
  }
}
