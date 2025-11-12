import 'dart:convert';

class ThemeLite {
  final int id;
  final String name;
  final Map<String, dynamic> valuesMobile;
  final String? menuType; // from valuesMobile['nav'] or 'menuType'

  ThemeLite({
    required this.id,
    required this.name,
    required this.valuesMobile,
    this.menuType,
  });

  factory ThemeLite.fromJson(Map<String, dynamic> j) {
    Map<String, dynamic> vm;
    final v = j['valuesMobile'];
    if (v is String) {
      try {
        vm = v.isEmpty ? {} : Map<String, dynamic>.from(jsonDecode(v) as Map);
      } catch (_) {
        vm = {};
      }
    } else if (v is Map) {
      vm = Map<String, dynamic>.from(v);
    } else {
      vm = {};
    }
    final menu = (vm['nav'] ?? vm['menuType'])?.toString();
    return ThemeLite(
      id: (j['id'] ?? 0) as int,
      name: (j['name'] ?? '').toString(),
      valuesMobile: vm,
      menuType: menu,
    );
  }

  static List<ThemeLite> list(dynamic data) {
    if (data is List) {
      return data
          .map((e) => ThemeLite.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return const [];
  }
}
