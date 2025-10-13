import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadThemes extends ThemeEvent {}

class RefreshThemes extends ThemeEvent {}

class CreateThemeEvent extends ThemeEvent {
  final Map<String, dynamic> body;
  CreateThemeEvent(this.body);
}

class UpdateThemeEvent extends ThemeEvent {
  final int id;
  final Map<String, dynamic> body;
  UpdateThemeEvent(this.id, this.body);
}

class DeleteThemeEvent extends ThemeEvent {
  final int id;
  DeleteThemeEvent(this.id);
}

class SetActiveThemeEvent extends ThemeEvent {
  final int id;
  SetActiveThemeEvent(this.id);
}

class SetMenuTypeEvent extends ThemeEvent {
  final int id;
  final String menuType;
  SetMenuTypeEvent(this.id, this.menuType);
}


class DeactivateAllThemesEvent extends ThemeEvent {}
