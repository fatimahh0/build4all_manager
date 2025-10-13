import '../entities/dashboard_overview.dart';
import '../entities/project_summary.dart';

abstract class IDashboardRepository {
  Future<(DashboardOverview overview, List<ProjectSummary> recent)> load();
}
