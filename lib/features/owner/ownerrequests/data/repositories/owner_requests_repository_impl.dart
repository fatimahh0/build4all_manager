import '../../domain/repositories/i_owner_requests_repository.dart';
import '../../domain/entities/app_request.dart';
import '../../domain/entities/project.dart';
import '../models/app_request_dto.dart';
import '../models/project_dto.dart';

import '../services/owner_requests_api.dart';
import '../services/themes_api.dart';
import '../../domain/entities/theme_lite.dart';

class OwnerRequestsRepositoryImpl implements IOwnerRequestsRepository {
  final OwnerRequestsApi api;
  final ThemesApi themesApi;
  OwnerRequestsRepositoryImpl(this.api, this.themesApi);

  Project _mapProject(ProjectDto d) => Project(
        id: d.id,
        name: d.projectName,
        description: d.description,
        active: d.active,
      );

  AppRequest _mapReq(AppRequestDto d) => AppRequest(
        id: d.id,
        ownerId: d.ownerId,
        projectId: d.projectId,
        appName: d.appName,
        notes: d.notes,
        status: d.status,
        createdAt: d.createdAt,
        // NEW:
        slug: d.slug,
        apkUrl: d.apkUrl,
      );

  @override
  Future<List<Project>> getAvailableProjects() async {
    final list = await api.getAvailableProjects();
    return list.map(_mapProject).toList();
  }

  @override
  Future<List<AppRequest>> getMyRequests(int ownerId) async {
    final list = await api.getMyRequests(ownerId);
    return list.map(_mapReq).toList();
  }

  @override
  Future<List<ThemeLite>> getThemes() => themesApi.getAll();

  @override
  Future<AppRequest> createAppRequestAuto({
    required int ownerId,
    required int projectId,
    required String appName,
    int? themeId,
    String? logoUrl,
    String? slug,
  }) async {
    final dto = await api.createAuto(
      ownerId: ownerId,
      projectId: projectId,
      appName: appName,
      themeId: themeId,
      logoUrl: logoUrl,
      slug: slug,
    );
    return _mapReq(dto);
  }
}
