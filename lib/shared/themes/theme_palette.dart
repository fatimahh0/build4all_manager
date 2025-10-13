import 'package:flutter/material.dart';

class ThemePalette {
  final String id; // e.g. 'emerald'
  final String name;
  final Color primary;
  final Color secondary;
  final Color success;
  final Color warning;
  final Color error;

  const ThemePalette({
    required this.id,
    required this.name,
    required this.primary,
    required this.secondary,
    required this.success,
    required this.warning,
    required this.error,
  });

  Map<String, int> toStorage() => {
        'primary': primary.value,
        'secondary': secondary.value,
        'success': success.value,
        'warning': warning.value,
        'error': error.value,
      };

  factory ThemePalette.fromStorage(
      String id, String name, Map<String, dynamic> m) {
    int v(dynamic x) => x is int ? x : int.parse(x.toString());
    return ThemePalette(
      id: id,
      name: name,
      primary: Color(v(m['primary'])),
      secondary: Color(v(m['secondary'])),
      success: Color(v(m['success'])),
      warning: Color(v(m['warning'])),
      error: Color(v(m['error'])),
    );
  }
}

class ThemeCatalog {
  static const emerald = ThemePalette(
    id: 'emerald',
    name: 'Emerald',
    primary: Color(0xFF0BA360),
    secondary: Color(0xFF0066CC),
    success: Color(0xFF2E7D32),
    warning: Color(0xFFF9A825),
    error: Color(0xFFC62828),
  );

  static const violet = ThemePalette(
    id: 'violet',
    name: 'Violet',
    primary: Color(0xFF6C63FF),
    secondary: Color(0xFF00B8D9),
    success: Color(0xFF2E7D32),
    warning: Color(0xFFFFA000),
    error: Color(0xFFD32F2F),
  );

  static const amber = ThemePalette(
    id: 'amber',
    name: 'Amber',
    primary: Color(0xFFFF8F00),
    secondary: Color(0xFF455A64),
    success: Color(0xFF43A047),
    warning: Color(0xFFFFC107),
    error: Color(0xFFE53935),
  );

  static const all = <ThemePalette>[emerald, violet, amber];
  static ThemePalette byId(String id) =>
      all.firstWhere((p) => p.id == id, orElse: () => emerald);
}
