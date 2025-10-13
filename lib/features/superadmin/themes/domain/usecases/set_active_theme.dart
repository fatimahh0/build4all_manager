import '../repositories/i_theme_repository.dart';

class SetActiveTheme {
  final IThemeRepository repo;
  SetActiveTheme(this.repo);
  Future<void> call(int id) => repo.setActive(id);
}
