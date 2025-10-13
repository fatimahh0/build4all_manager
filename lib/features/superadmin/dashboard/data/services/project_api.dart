import 'package:dio/dio.dart';

class ProjectApi {
  final Dio dio;
  ProjectApi(this.dio);

  /// GET /api/projects → list of projects (per your backend)
  Future<Response> list() => dio.get('/projects');
}
