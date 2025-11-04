import 'package:dio/dio.dart';
import '../models/project_dto.dart';
import '../models/app_request_dto.dart';

class OwnerRequestsApi {
  final Dio dio;
  OwnerRequestsApi(this.dio);

  Future<List<ProjectDto>> getAvailableProjects() async {
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

  /// NEW: upload a logo file to the admin apps logo endpoint (multipart)
  /// Backend controller: /api/admin-users/{adminId}/projects/{projectId}/apps/{slug}/logo
  Future<Map<String, String>> uploadLogo({
    required int adminId, // == ownerId in your app
    required int projectId,
    required String slug,
    required String filePath,
  }) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: 'logo.png'),
    });

    final res = await dio.post(
      '/admin-users/$adminId/projects/$projectId/apps/$slug/logo',
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );

    final data = (res.data as Map)
        .map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
    // returns { logoUrl, apkUrl }
    return {
      'logoUrl': data['logoUrl'] ?? '',
      'apkUrl': data['apkUrl'] ?? '',
    };
  }

  /// Auto-approve endpoint
  Future<AppRequestDto> createAuto({
    required int ownerId,
    required int projectId,
    required String appName,
    String? slug, // <-- allow sending the slug we used for upload
    int? themeId,
    String? logoUrl,
  }) async {
    final body = {
      'projectId': projectId,
      'appName': appName,
      'slug':
          slug, // if null, backend slugifies; if non-null, matches upload path
      'logoUrl': logoUrl,
      'themeId': themeId,
      'notes': null,
    };
    final res = await dio.post(
      '/owner/app-requests/auto',
      queryParameters: {'ownerId': ownerId},
      data: body,
    );
    return AppRequestDto.fromJson(res.data as Map<String, dynamic>);
  }
}
