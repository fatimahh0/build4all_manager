import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../../domain/entities/project_summary.dart';

class DashboardState extends Equatable {
  final bool loading;
  final DashboardOverview? overview;
  final List<ProjectSummary> recent;
  final String? error;

  const DashboardState({
    this.loading = false,
    this.overview,
    this.recent = const [],
    this.error,
  });

  DashboardState copyWith({
    bool? loading,
    DashboardOverview? overview,
    List<ProjectSummary>? recent,
    String? error,
  }) =>
      DashboardState(
        loading: loading ?? this.loading,
        overview: overview ?? this.overview,
        recent: recent ?? this.recent,
        error: error,
      );

  @override
  List<Object?> get props => [loading, overview ?? '', recent, error ?? ''];
}
