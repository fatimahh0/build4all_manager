import '../repositories/i_theme_repository.dart';

class DeleteTheme {
  final IThemeRepository repo;
  DeleteTheme(this.repo);
  Future<void> call(int id) => repo.delete(id);
}
