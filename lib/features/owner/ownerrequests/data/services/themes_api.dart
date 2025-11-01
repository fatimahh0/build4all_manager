// lib/features/owner/ownerrequests/data/services/themes_api.dart
import 'package:build4all_manager/features/owner/ownerrequests/domain/entities/theme_lite.dart';
import 'package:dio/dio.dart';


class ThemesApi {
  final Dio dio;
  ThemesApi(this.dio);

  /// Pull all themes (mobile-friendly values included)
  Future<List<ThemeLite>> getAll() async {
    // If your backend exposes /api/themes/all or /api/themes/all/mobile
    // choose what returns valuesMobile. You showed /api/themes/all.
    final res = await dio.get('/themes/all');
    return ThemeLite.list(res.data);
  }
}
