import '../../domain/entities/dashboard_overview.dart';
import '../../domain/entities/project_summary.dart';
import '../../domain/repositories/i_dashboard_repository.dart';
import '../models/project_dto.dart';
import '../services/project_api.dart';

class DashboardRepositoryImpl implements IDashboardRepository {
  final ProjectApi projects;
  DashboardRepositoryImpl(this.projects);

  @override
  Future<(DashboardOverview, List<ProjectSummary>)> load() async {
    final res = await projects.list();
    final list = (res.data as List).cast<Map<String, dynamic>>();
    final items = list.map((e) => ProjectDto.fromJson(e).toEntity()).toList();

    final total = items.length;
    final active = items.where((e) => e.active).length;
    final inactive = total - active;

    // sort by updatedAt desc and take the latest 8
    items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final recent = items.take(8).toList();

    return (
      DashboardOverview(
        totalProjects: total,
        activeProjects: active,
        inactiveProjects: inactive,
      ),
      recent
    );
  }
}
