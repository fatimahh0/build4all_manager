import 'package:equatable/equatable.dart';
import '../../../common/domain/entities/app_config.dart';
import '../../../common/domain/entities/app_request.dart';

class OwnerHomeState extends Equatable {
  final bool loading;
  final List<AppRequest> recent;
  final AppConfig? config;
  final String? error;

  const OwnerHomeState({
    this.loading = false,
    this.recent = const [],
    this.config,
    this.error,
  });

  OwnerHomeState copyWith({
    bool? loading,
    List<AppRequest>? recent,
    AppConfig? config,
    String? error,
  }) =>
      OwnerHomeState(
        loading: loading ?? this.loading,
        recent: recent ?? this.recent,
        config: config ?? this.config,
        error: error,
      );

  @override
  List<Object?> get props => [loading, recent, config, error];
}
