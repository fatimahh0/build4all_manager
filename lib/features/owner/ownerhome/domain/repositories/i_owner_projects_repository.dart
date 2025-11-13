import '../entities/backend_project.dart';

abstract class IOwnerProjectsRepository {
  Future<List<BackendProject>> getProjects();
}
