import '../entities/app_request.dart';
import '../entities/project.dart';

abstract class IOwnerRequestsRepository {
  Future<List<Project>> getAvailableProjects();
  Future<AppRequest> createAppRequest({
    required int ownerId,
    required int projectId,
    required String appName,
    String? notes, // use for theme info for now
  });
  Future<List<AppRequest>> getMyRequests(int ownerId);
}
