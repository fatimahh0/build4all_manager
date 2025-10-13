import '../entities/theme_entity.dart';

abstract class IThemeRepository {
  Future<List<ThemeEntity>> getAll();
  Future<ThemeEntity?> getActive();
  Future<ThemeEntity> create(Map<String, dynamic> body);
  Future<ThemeEntity> update(int id, Map<String, dynamic> body);
  Future<void> delete(int id);
  Future<void> setActive(int id);
  Future<void> setMenuType(int id, String menuType);
  Future<int> deactivateAll();
}
