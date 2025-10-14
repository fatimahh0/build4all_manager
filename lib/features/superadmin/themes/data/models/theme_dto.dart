import 'dart:convert';
import '../../domain/entities/theme_entity.dart';

class ThemeDto {
  final int id;
  final String name;
  final bool active; // server uses isActive
  final String menuType;
  final int? primary, secondary, success, warning, error;

  ThemeDto({
    required this.id,
    required this.name,
    required this.active,
    required this.menuType,
    this.primary,
    this.secondary,
    this.success,
    this.warning,
    this.error,
  });

  factory ThemeDto.fromJson(Map<String, dynamic> j) {
    // server payload looks like:
    // { id, name, values: "{}", valuesMobile: "{\"primaryColor\":\"#0e7490\",...}", isActive, createdAt, updatedAt }
    final bool isActive = (j['isActive'] ?? j['active'] ?? false) as bool;

    // parse valuesMobile even if it’s a string
    final vm = _readValuesMobile(j['valuesMobile']);

    return ThemeDto(
      id: (j['id'] as num).toInt(),
      name: (j['name'] ?? '').toString(),
      active: isActive,
      menuType: (j['menuType'] ?? (vm['nav'] ?? 'bottom')).toString(),
      primary: _hexToArgb(vm['primaryColor']),
      secondary: _hexToArgb(vm['secondaryColor']),
      success: _hexToArgb(vm['successColor']),
      warning: _hexToArgb(vm['warningColor']),
      error: _hexToArgb(vm['errorColor']),
    );
  }

  ThemeEntity toEntity() => ThemeEntity(
        id: id,
        name: name,
        active: active,
        menuType: menuType,
        primary: primary,
        secondary: secondary,
        success: success,
        warning: warning,
        error: error,
      );

  // ---------- helpers ----------

  static Map<String, dynamic> _readValuesMobile(dynamic raw) {
    if (raw == null) return <String, dynamic>{};
    if (raw is Map<String, dynamic>) return raw;
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        final m = jsonDecode(raw);
        return (m is Map<String, dynamic>) ? m : <String, dynamic>{};
      } catch (_) {
        return <String, dynamic>{};
      }
    }
    return <String, dynamic>{};
  }

  /// Accepts "#rgb", "#rrggbb", "#aarrggbb" or int/num → returns 0xAARRGGBB.
  static int? _hexToArgb(dynamic v) {
    if (v == null) return null;
    if (v is int) {
      // if the int looks like RGB (<= 0xFFFFFF), force opaque
      return (v <= 0xFFFFFF) ? (0xFF000000 | v) : v;
    }
    final s0 = v.toString().trim();
    if (s0.isEmpty) return null;

    String s = s0.startsWith('#') ? s0.substring(1) : s0;

    // short #rgb
    if (s.length == 3) {
      s = '${s[0]}${s[0]}${s[1]}${s[1]}${s[2]}${s[2]}';
    }
    // #aarrggbb → drop alpha into int’s high byte
    if (s.length == 8) {
      final a = s.substring(0, 2);
      final r = s.substring(2, 4);
      final g = s.substring(4, 6);
      final b = s.substring(6, 8);
      return int.tryParse('0x$a$r$g$b');
    }
    // #rrggbb
    if (s.length == 6) {
      return int.tryParse('0xFF$s');
    }
    // fallback: maybe decimal string
    final n = int.tryParse(s);
    if (n == null) return null;
    return (n <= 0xFFFFFF) ? (0xFF000000 | n) : n;
  }
}
