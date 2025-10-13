import '../../domain/entities/theme_entity.dart';
import '../../domain/repositories/i_theme_repository.dart';
import '../models/theme_dto.dart';
import '../services/theme_api.dart';

class ThemeRepositoryImpl implements IThemeRepository {
  final ThemeApi api;
  ThemeRepositoryImpl(this.api);

  @override
  Future<List<ThemeEntity>> getAll() async {
    final r = await api.getAll();
    final list = (r.data as List).cast<Map<String, dynamic>>();
    return list.map((e) => ThemeDto.fromJson(e).toEntity()).toList();
  }

  @override
  Future<ThemeEntity?> getActive() async {
    try {
      final r = await api.getActive();
      return ThemeDto.fromJson(Map<String, dynamic>.from(r.data)).toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ThemeEntity> create(Map<String, dynamic> body) async {
    final r = await api.create(body);
    final dto = Map<String, dynamic>.from(r.data['theme'] ?? r.data);
    return ThemeDto.fromJson(dto).toEntity();
    // server sometimes returns {message, theme:{...}}
  }

  @override
  Future<ThemeEntity> update(int id, Map<String, dynamic> body) async {
    final r = await api.update(id, body);
    return ThemeDto.fromJson(Map<String, dynamic>.from(r.data)).toEntity();
  }

  @override
  Future<void> delete(int id) => api.delete(id).then((_) {});

  @override
  Future<void> setActive(int id) => api.setActive(id).then((_) {});

  @override
  Future<void> setMenuType(int id, String menuType) =>
      api.setMenuType(id, menuType).then((_) {});

  @override
  Future<int> deactivateAll() async {
    final r = await api.deactivateAll();
    final m = Map<String, dynamic>.from(r.data);
    final n = m['updatedCount'];
    return n is int ? n : int.tryParse('$n') ?? 0;
  }
}
