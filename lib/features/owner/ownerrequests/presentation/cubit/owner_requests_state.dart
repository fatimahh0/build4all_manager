// lib/features/owner/ownerrequests/presentation/cubit/owner_requests_state.dart
part of 'owner_requests_cubit.dart';

class OwnerRequestsState extends Equatable {
  final bool loading;
  final bool submitting;
  final String? error;

  final List<Project> projects;
  final List<AppRequest> myRequests;

  final List<ThemeLite> themes; // ✅ ThemeLite list
  final int? selectedThemeId; // ✅ selected theme id
  final String? logoUrl; // ✅ optional logo

  final Project? selected;
  final String appName;

  final AppRequest? lastCreated;

  const OwnerRequestsState({
    required this.loading,
    required this.submitting,
    required this.error,
    required this.projects,
    required this.myRequests,
    required this.themes,
    required this.selectedThemeId,
    required this.logoUrl,
    required this.selected,
    required this.appName,
    required this.lastCreated,
  });

  const OwnerRequestsState.initial()
      : loading = false,
        submitting = false,
        error = null,
        projects = const [],
        myRequests = const [],
        themes = const [],
        selectedThemeId = null,
        logoUrl = null,
        selected = null,
        appName = '',
        lastCreated = null;

  OwnerRequestsState copyWith({
    bool? loading,
    bool? submitting,
    String? error,
    List<Project>? projects,
    List<AppRequest>? myRequests,
    List<ThemeLite>? themes,
    int? selectedThemeId,
    String? logoUrl,
    Project? selected,
    String? appName,
    AppRequest? lastCreated,
  }) {
    return OwnerRequestsState(
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      error: error,
      projects: projects ?? this.projects,
      myRequests: myRequests ?? this.myRequests,
      themes: themes ?? this.themes,
      selectedThemeId: selectedThemeId ?? this.selectedThemeId,
      logoUrl: logoUrl ?? this.logoUrl,
      selected: selected ?? this.selected,
      appName: appName ?? this.appName,
      lastCreated: lastCreated ?? this.lastCreated,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        submitting,
        error,
        projects,
        myRequests,
        themes,
        selectedThemeId,
        logoUrl,
        selected,
        appName,
        lastCreated,
      ];
}
