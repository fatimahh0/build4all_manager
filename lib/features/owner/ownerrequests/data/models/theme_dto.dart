import 'dart:convert';

class ThemeDto {
  final int id;
  final String name;

  /// Raw mobile JSON (already string on the wire)
  final String? valuesMobileRaw;

  /// Parsed mobile map (primaryColor, nav, etc.)
  final Map<String, dynamic> valuesMobile;

  ThemeDto({
    required this.id,
    required this.name,
    required this.valuesMobileRaw,
    required this.valuesMobile,
  });

  /// Safe parse helper
  static Map<String, dynamic> _parseValuesMobile(dynamic v) {
    if (v == null) return const {};
    try {
      if (v is Map<String, dynamic>) return v;
      if (v is String && v.trim().isNotEmpty) {
        return json.decode(v) as Map<String, dynamic>;
      }
    } catch (_) {}
    return const {};
  }

  /// Convenience getter: bottom/top/drawer (your JSON uses "nav")
  String? get menuType {
    final nav = valuesMobile['nav'];
    return nav is String ? nav : null;
  }

  factory ThemeDto.fromJson(Map<String, dynamic> j) {
    final raw = j['valuesMobile']?.toString();
    final parsed = _parseValuesMobile(raw);
    return ThemeDto(
      id: (j['id'] ?? 0) as int,
      name: (j['name'] ?? '').toString(),
      valuesMobileRaw: raw,
      valuesMobile: parsed,
    );
  }

  static List<ThemeDto> list(dynamic data) {
    if (data is List) {
      return data
          .map((e) => ThemeDto.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return const [];
  }
}
