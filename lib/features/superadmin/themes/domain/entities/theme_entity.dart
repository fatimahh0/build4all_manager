class ThemeEntity {
  final int id;
  final String name;
  final bool active;
  final String menuType; // "bottom" | "top" | "drawer"
  final int? primary;
  final int? secondary;
  final int? success;
  final int? warning;
  final int? error;

  const ThemeEntity({
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

  ThemeEntity copyWith({
    String? name,
    bool? active,
    String? menuType,
    int? primary,
    int? secondary,
    int? success,
    int? warning,
    int? error,
  }) {
    return ThemeEntity(
      id: id,
      name: name ?? this.name,
      active: active ?? this.active,
      menuType: menuType ?? this.menuType,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
    );
  }
}
