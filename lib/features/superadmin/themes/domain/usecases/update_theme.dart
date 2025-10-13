import '../entities/theme_entity.dart';
import '../repositories/i_theme_repository.dart';

class UpdateTheme {
  final IThemeRepository repo;
  UpdateTheme(this.repo);
  Future<ThemeEntity> call(int id, Map<String, dynamic> body) =>
      repo.update(id, body);
}
