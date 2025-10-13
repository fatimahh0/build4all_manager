import '../repositories/i_theme_repository.dart';

class DeactivateAllThemes {
  final IThemeRepository repo;
  DeactivateAllThemes(this.repo);
  Future<int> call() => repo.deactivateAll();
}
