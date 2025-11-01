// lib/features/owner/ownerrequests/data/models/theme_lite.dart
import 'dart:convert';

/// Minimal theme model for picker (from /api/themes/all or /all/mobile)
class ThemeLite {
  final int id;
  final String name;
  final Map<String, dynamic>
      valuesMobile; // expects primaryColor, nav/menu type
  final String? menuType; // derived from valuesMobile['nav'] or backend field

  ThemeLite({
    required this.id,
    required this.name,
    required this.valuesMobile,
    this.menuType,
  });

  factory ThemeLite.fromJson(Map<String, dynamic> j) {
    // valuesMobile may be JSON string or map
    dynamic vm = j['valuesMobile'];
    Map<String, dynamic> m;
    if (vm is String) {
      try {
        m = (vm.isEmpty)
            ? <String, dynamic>{}
            : Map<String, dynamic>.from((vm.startsWith('{'))
                ? (jsonDecode(vm) as Map)
                : <String, dynamic>{});
      } catch (_) {
        m = <String, dynamic>{};
      }
    } else if (vm is Map) {
      m = Map<String, dynamic>.from(vm);
    } else {
      m = <String, dynamic>{};
    }

    final menu = (m['nav'] ?? m['menuType'])?.toString();

    return ThemeLite(
      id: (j['id'] ?? 0) as int,
      name: (j['name'] ?? '').toString(),
      valuesMobile: m,
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
