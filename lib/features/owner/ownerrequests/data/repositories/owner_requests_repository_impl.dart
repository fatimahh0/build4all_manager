import '../../domain/entities/app_request.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/i_owner_requests_repository.dart';
import '../models/app_request_dto.dart';
import '../models/project_dto.dart';
import '../services/owner_requests_api.dart';

class OwnerRequestsRepositoryImpl implements IOwnerRequestsRepository {
  final OwnerRequestsApi api;
  OwnerRequestsRepositoryImpl(this.api);

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
      );

  @override
  Future<List<Project>> getAvailableProjects() async {
    final list = await api.getAvailableProjects();
    return list.map(_mapProject).toList();
  }

  @override
  Future<AppRequest> createAppRequest({
    required int ownerId,
    required int projectId,
    required String appName,
    String? notes,
  }) async {
    final dto = await api.createAppRequest(
      ownerId: ownerId,
      projectId: projectId,
      appName: appName,
      notes: notes,
    );
    return _mapReq(dto);
  }

  @override
  Future<List<AppRequest>> getMyRequests(int ownerId) async {
    final list = await api.getMyRequests(ownerId);
    return list.map(_mapReq).toList();
  }
}
