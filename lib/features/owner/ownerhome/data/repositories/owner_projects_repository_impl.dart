import '../../domain/entities/backend_project.dart';
import '../../domain/repositories/i_owner_projects_repository.dart';
import '../services/owner_projects_api.dart';

class OwnerProjectsRepositoryImpl implements IOwnerProjectsRepository {
  final OwnerProjectsApi api;
  OwnerProjectsRepositoryImpl(this.api);

  @override
  Future<List<BackendProject>> getProjects() async {
    final dtos = await api.fetchProjects();
    return dtos.map((d) => d.toEntity()).toList();
  }
}
