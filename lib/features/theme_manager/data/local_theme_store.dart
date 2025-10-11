import 'package:shared_preferences/shared_preferences.dart';

class LocalThemeStore {
  static const _kPaletteId = 'theme_palette_id';
  static const _kCustomPrefix = 'theme_custom_'; // e.g. theme_custom_primary
  static const _kDarkMode = 'theme_dark_mode'; // 0: light, 1: dark, 2: system

  Future<void> savePaletteId(String id) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kPaletteId, id);
  }

  Future<String?> readPaletteId() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kPaletteId);
  }

  Future<void> saveCustomColor(String key, int argb) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('$_kCustomPrefix$key', argb);
  }

  Future<Map<String, int>> readCustom() async {
    final p = await SharedPreferences.getInstance();
    int? get(String k) => p.getInt('$_kCustomPrefix$k');
    final m = <String, int>{};
    for (final k in ['primary', 'secondary', 'success', 'warning', 'error']) {
      final v = get(k);
      if (v != null) m[k] = v;
    }
    return m;
  }

  Future<void> saveThemeMode(int mode) async {
    // 0 light, 1 dark, 2 system
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kDarkMode, mode);
  }

  Future<int> readThemeMode() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_kDarkMode) ?? 2;
  }
}
