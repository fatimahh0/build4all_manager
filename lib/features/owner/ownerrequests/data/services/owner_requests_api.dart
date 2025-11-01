// lib/features/owner/ownerrequests/data/services/owner_requests_api.dart
import 'package:dio/dio.dart';
import '../models/project_dto.dart';
import '../models/app_request_dto.dart';

class OwnerRequestsApi {
  final Dio dio;
  OwnerRequestsApi(this.dio);

  Future<List<ProjectDto>> getAvailableProjects() async {
    // Adjust if your real endpoint is different
    final res = await dio.get('/projects');
    return ProjectDto.list(res.data);
  }

  Future<List<AppRequestDto>> getMyRequests(int ownerId) async {
    final res = await dio.get(
      '/owner/app-requests',
      queryParameters: {'ownerId': ownerId},
    );
    return AppRequestDto.list(res.data);
  }

  /// Auto-approve endpoint
  Future<AppRequestDto> createAuto({
    required int ownerId,
    required int projectId,
    required String appName,
    int? themeId,
    String? logoUrl,
  }) async {
    final body = {
      'projectId': projectId,
      'appName': appName,
      'slug': null, // backend slugifies
      'logoUrl': logoUrl,
      'themeId': themeId,
      'notes': null, // optional notes if needed
    };
    final res = await dio.post(
      '/owner/app-requests/auto',
      queryParameters: {'ownerId': ownerId},
      data: body,
    );
    return AppRequestDto.fromJson(res.data as Map<String, dynamic>);
  }
}
