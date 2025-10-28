import 'package:equatable/equatable.dart';
import '../../../common/domain/entities/app_config.dart';
import '../../../common/domain/entities/app_request.dart';
import '../../../common/domain/entities/owner_project.dart';

class OwnerHomeState extends Equatable {
  final bool loading;
  final List<OwnerProject> apps;
  final List<AppRequest> recent;
  final AppConfig? config;
  final String? error;

  const OwnerHomeState({
    this.loading = false,
    this.apps = const [],
    this.recent = const [],
    this.config,
    this.error,
  });

  OwnerHomeState copyWith({
    bool? loading,
    List<OwnerProject>? apps,
    List<AppRequest>? recent,
    AppConfig? config,
    String? error,
  }) {
    return OwnerHomeState(
      loading: loading ?? this.loading,
      apps: apps ?? this.apps,
      recent: recent ?? this.recent,
      config: config ?? this.config,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, apps, recent, config, error];
}
