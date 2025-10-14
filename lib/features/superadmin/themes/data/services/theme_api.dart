import 'package:dio/dio.dart';

class ThemeApi {
  final Dio dio;
  ThemeApi(this.dio);

  Future<Response> getAll() => dio.get('/themes/all');

  // don't throw on 404 → we map to null in repo
  Future<Response> getActive() => dio.get(
        '/themes/active',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

  Future<Response> create(Map<String, dynamic> body) =>
      dio.post('/themes/create', data: body);

  Future<Response> update(int id, Map<String, dynamic> body) =>
      dio.put('/themes/$id', data: body);

  Future<Response> delete(int id) => dio.delete('/themes/$id/delete');

  Future<Response> setActive(int id) =>
      dio.put('/themes/$id/set-active', data: const {});

  Future<Response> setMenuType(int id, String type) =>
      dio.put('/themes/$id/set-menu-type', data: {'menuType': type});

  Future<Response> deactivateAll() => dio.put('/themes/deactivate-all');
}
