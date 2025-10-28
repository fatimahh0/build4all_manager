part of 'owner_requests_cubit.dart';

class OwnerRequestsState extends Equatable {
  final bool loading;
  final bool submitting;
  final String? error;

  final List<Project> projects;
  final List<AppRequest> myRequests;

  final Project? selected;
  final String appName;
  final String? themeChoice;

  final AppRequest? lastCreated;

  const OwnerRequestsState({
    required this.loading,
    required this.submitting,
    required this.error,
    required this.projects,
    required this.myRequests,
    required this.selected,
    required this.appName,
    required this.themeChoice,
    required this.lastCreated,
  });

  const OwnerRequestsState.initial()
      : loading = false,
        submitting = false,
        error = null,
        projects = const [],
        myRequests = const [],
        selected = null,
        appName = '',
        themeChoice = null,
        lastCreated = null;

  OwnerRequestsState copyWith({
    bool? loading,
    bool? submitting,
    String? error,
    List<Project>? projects,
    List<AppRequest>? myRequests,
    Project? selected,
    String? appName,
    String? themeChoice,
    AppRequest? lastCreated,
  }) {
    return OwnerRequestsState(
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      error: error,
      projects: projects ?? this.projects,
      myRequests: myRequests ?? this.myRequests,
      selected: selected,
      appName: appName ?? this.appName,
      themeChoice: themeChoice,
      lastCreated: lastCreated,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        submitting,
        error,
        projects,
        myRequests,
        selected,
        appName,
        themeChoice,
        lastCreated,
      ];
}
