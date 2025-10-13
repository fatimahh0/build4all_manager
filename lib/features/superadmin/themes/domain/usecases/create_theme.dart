import '../entities/theme_entity.dart';
import '../repositories/i_theme_repository.dart';

class CreateTheme {
  final IThemeRepository repo;
  CreateTheme(this.repo);
  Future<ThemeEntity> call(Map<String, dynamic> body) => repo.create(body);
}
