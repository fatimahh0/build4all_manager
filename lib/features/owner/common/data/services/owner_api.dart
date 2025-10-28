import 'package:dio/dio.dart';

import '../models/app_config_dto.dart';
import '../models/app_request_dto.dart';
import '../models/owner_project_dto.dart';

class OwnerApi {
  final Dio dio;
  OwnerApi(this.dio);

  Future<AppConfigDto> getAppConfig() async {
    final r = await dio.get('/public/app-config');
    return AppConfigDto.fromJson(r.data as Map<String, dynamic>);
  }

  Future<List<AppRequestDto>> getMyRequests({required int ownerId}) async {
    final r = await dio.get(
      '/owner/app-requests',
      queryParameters: {'ownerId': ownerId},
    );
    return (r.data as List)
        .map((e) => AppRequestDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<OwnerProjectDto>> getMyApps({required int ownerId}) async {
    final r = await dio.get(
      '/owner/my-apps',
      queryParameters: {'ownerId': ownerId},
    );
    return (r.data as List)
        .map((e) => OwnerProjectDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
