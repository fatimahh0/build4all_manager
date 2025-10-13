import '../repositories/i_theme_repository.dart';

class SetMenuType {
  final IThemeRepository repo;
  SetMenuType(this.repo);
  Future<void> call(int id, String menuType) => repo.setMenuType(id, menuType);
}
