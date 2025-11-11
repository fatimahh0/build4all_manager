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

  /// One-shot create+approve+trigger CI (multipart).
  /// If [logoFilePath] is provided, we attach it as "file".
  /// If not, but [logoUrl] is provided, we send it as a normal field.
  Future<AppRequestDto> createAuto({
    required int ownerId,
    required int projectId,
    required String appName,
    String? slug,
    int? themeId,
    String? notes,
    String? logoUrl, // optional when no file
    String? logoFilePath, // optional file path to upload
  }) async {
    final form = FormData();

    // scalar fields
    form.fields
      ..add(MapEntry('projectId', projectId.toString()))
      ..add(MapEntry('appName', appName));
    if (slug != null && slug.trim().isNotEmpty) {
      form.fields.add(MapEntry('slug', slug.trim()));
    }
    if (themeId != null) {
      form.fields.add(MapEntry('themeId', themeId.toString()));
    }
    if (notes != null && notes.trim().isNotEmpty) {
      form.fields.add(MapEntry('notes', notes.trim()));
    }

    // either attach a file or pass logoUrl
    if (logoFilePath != null && logoFilePath.isNotEmpty) {
      form.files.add(MapEntry(
        'file',
        await MultipartFile.fromFile(logoFilePath, filename: 'logo.png'),
      ));
    } else if (logoUrl != null && logoUrl.trim().isNotEmpty) {
      form.fields.add(MapEntry('logoUrl', logoUrl.trim()));
    }

    final res = await dio.post(
      '/owner/app-requests/auto',
      queryParameters: {'ownerId': ownerId},
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );

    return AppRequestDto.fromJson(res.data as Map<String, dynamic>);
  }
}
