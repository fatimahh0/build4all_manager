import '../../domain/entities/theme_entity.dart';

class ThemeDto {
  final int id;
  final String name;
  final bool active;
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

  factory ThemeDto.fromJson(Map<String, dynamic> j) => ThemeDto(
        id: (j['id'] as num).toInt(),
        name: (j['name'] ?? '').toString(),
        active: (j['active'] ?? false) as bool,
        menuType: (j['menuType'] ?? 'bottom').toString(),
        primary: _intOrNull(j['primary']),
        secondary: _intOrNull(j['secondary']),
        success: _intOrNull(j['success']),
        warning: _intOrNull(j['warning']),
        error: _intOrNull(j['error']),
      );

  static int? _intOrNull(dynamic x) {
    if (x == null) return null;
    if (x is int) return x;
    try {
      return int.parse('$x');
    } catch (_) {
      return null;
    }
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
}
