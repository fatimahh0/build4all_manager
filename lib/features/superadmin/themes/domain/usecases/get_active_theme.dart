import '../entities/theme_entity.dart';
import '../repositories/i_theme_repository.dart';

class GetActiveTheme {
  final IThemeRepository repo;
  GetActiveTheme(this.repo);
  Future<ThemeEntity?> call() => repo.getActive();
}
