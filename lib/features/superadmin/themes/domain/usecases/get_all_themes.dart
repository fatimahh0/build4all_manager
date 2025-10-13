import '../entities/theme_entity.dart';
import '../repositories/i_theme_repository.dart';

class GetAllThemes {
  final IThemeRepository repo;
  GetAllThemes(this.repo);
  Future<List<ThemeEntity>> call() => repo.getAll();
}
