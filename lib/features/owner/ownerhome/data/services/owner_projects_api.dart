import 'package:build4all_manager/features/owner/ownerhome/data/models/backend_project_dto.dart';
import 'package:dio/dio.dart';


class OwnerProjectsApi {
  final Dio dio;
  OwnerProjectsApi(this.dio);

  Future<List<BackendProjectDto>> fetchProjects() async {
    // GET /api/projects
    final res = await dio.get('/api/projects');
    final data = (res.data as List?) ?? const [];
    return data
        .map((e) => BackendProjectDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
