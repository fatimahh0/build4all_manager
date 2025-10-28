import 'package:dio/dio.dart';
import '../models/project_dto.dart';
import '../models/app_request_dto.dart';

class OwnerRequestsApi {
  final Dio _dio;
  final String baseUrl;

  OwnerRequestsApi({required Dio dio, required this.baseUrl}) : _dio = dio;

  Future<List<ProjectDto>> getAvailableProjects() async {
    final res = await _dio.get('$baseUrl/api/projects');
    return ProjectDto.list(res.data);
    // No auth required per your ProjectController.list()
  }

  Future<AppRequestDto> createAppRequest({
    required int ownerId,
    required int projectId,
    required String appName,
    String? notes,
  }) async {
    final body = {
      'projectId': projectId,
      'appName': appName,
      'notes': notes ?? '',
    };
    final res = await _dio.post(
      '$baseUrl/api/owner/app-requests',
      queryParameters: {'ownerId': ownerId},
      data: body,
    );
    return AppRequestDto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<List<AppRequestDto>> getMyRequests(int ownerId) async {
    final res = await _dio.get(
      '$baseUrl/api/owner/app-requests',
      queryParameters: {'ownerId': ownerId},
    );
    return AppRequestDto.list(res.data);
  }
}
