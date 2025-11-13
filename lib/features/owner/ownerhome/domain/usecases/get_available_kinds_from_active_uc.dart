import '../entities/backend_project.dart';
import '../repositories/i_owner_projects_repository.dart';

class _KindMapper {
  static String? map(BackendProject p) {
    if (!p.active) return null;
    final n = p.name.toLowerCase();

    if (p.id == 1 || n.contains('default') || n.contains('activity')) {
      return 'activities';
    }
    if (n.contains('ecommerce') || n.contains('shop')) return 'ecommerce';
    if (n.contains('gym') || n.contains('fitness')) return 'gym';
    if (n.contains('service')) return 'services';

    return null;
  }
}

class GetAvailableKindsFromActiveUc {
  final IOwnerProjectsRepository repo;
  const GetAvailableKindsFromActiveUc(this.repo);

  Future<Set<String>> call() async {
    final list = await repo.getProjects();
    final kinds = <String>{};
    for (final p in list) {
      final k = _KindMapper.map(p);
      if (k != null) kinds.add(k);
    }
    return kinds;
  }
}
