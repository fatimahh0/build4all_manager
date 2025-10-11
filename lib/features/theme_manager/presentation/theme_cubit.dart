import 'package:build4all_manager/core/themes/app_theme.dart';
import 'package:build4all_manager/core/themes/theme_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/local_theme_store.dart';

class ThemeVM {
  final ThemePalette palette;
  final ThemeMode mode; // light / dark / system
  final ThemeData light;
  final ThemeData dark;

  const ThemeVM({
    required this.palette,
    required this.mode,
    required this.light,
    required this.dark,
  });

  ThemeVM copyWith({ThemePalette? palette, ThemeMode? mode}) {
    final pal = palette ?? this.palette;
    final m = mode ?? this.mode;
    return ThemeVM(
      palette: pal,
      mode: m,
      light: AppTheme.build(pal, brightness: Brightness.light),
      dark: AppTheme.build(pal, brightness: Brightness.dark),
    );
  }
}

class ThemeCubit extends Cubit<ThemeVM> {
  final LocalThemeStore store;
  ThemeCubit(this.store)
      : super(ThemeVM(
          palette: ThemeCatalog.emerald,
          mode: ThemeMode.system,
          light: AppTheme.build(ThemeCatalog.emerald),
          dark:
              AppTheme.build(ThemeCatalog.emerald, brightness: Brightness.dark),
        ));

  Future<void> load() async {
    final id = await store.readPaletteId();
    final modeInt = await store.readThemeMode();
    final custom = await store.readCustom();

    ThemePalette p = id != null ? ThemeCatalog.byId(id) : ThemeCatalog.emerald;
    if (id == 'custom' && custom.isNotEmpty) {
      p = ThemePalette.fromStorage('custom', 'Custom', custom);
    }
    final mode = switch (modeInt) {
      0 => ThemeMode.light,
      1 => ThemeMode.dark,
      _ => ThemeMode.system
    };
    emit(state.copyWith(palette: p, mode: mode));
  }

  Future<void> selectPalette(String id) async {
    final p = id == 'custom' ? state.palette : ThemeCatalog.byId(id);
    await store.savePaletteId(id);
    emit(state.copyWith(palette: p));
  }

  Future<void> setCustomColor(String key, Color color) async {
    await store.saveCustomColor(key, color.value);
    await store.savePaletteId('custom');
    final p = ThemePalette(
      id: 'custom',
      name: 'Custom',
      primary: key == 'primary' ? color : state.palette.primary,
      secondary: key == 'secondary' ? color : state.palette.secondary,
      success: key == 'success' ? color : state.palette.success,
      warning: key == 'warning' ? color : state.palette.warning,
      error: key == 'error' ? color : state.palette.error,
    );
    emit(state.copyWith(palette: p));
  }

  Future<void> setMode(ThemeMode mode) async {
    final v =
        switch (mode) { ThemeMode.light => 0, ThemeMode.dark => 1, _ => 2 };
    await store.saveThemeMode(v);
    emit(state.copyWith(mode: mode));
  }
}
