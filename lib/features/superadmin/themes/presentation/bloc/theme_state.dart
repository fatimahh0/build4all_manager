import 'package:equatable/equatable.dart';
import '../../domain/entities/theme_entity.dart';

class ThemeState extends Equatable {
  final bool loading;
  final List<ThemeEntity> items;
  final String? error;
  final int? activeId;

  const ThemeState({
    this.loading = true,
    this.items = const [],
    this.error,
    this.activeId,
  });

  ThemeState copyWith({
    bool? loading,
    List<ThemeEntity>? items,
    String? error,
    int? activeId,
  }) {
    return ThemeState(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      error: error,
      activeId: activeId ?? this.activeId,
    );
  }

  @override
  List<Object?> get props => [loading, items, error, activeId];
}
