import 'package:dio/dio.dart';
import '../../domain/entities/theme_lite.dart';

class ThemesApi {
  final Dio dio;
  ThemesApi(this.dio);

  Future<List<ThemeLite>> getAll() async {
    final res = await dio.get('/themes/all');
    return ThemeLite.list(res.data);
  }
}
