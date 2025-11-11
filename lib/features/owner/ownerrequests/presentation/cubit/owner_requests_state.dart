// lib/features/owner/ownerrequests/presentation/cubit/owner_requests_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/app_request.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/theme_lite.dart';

class OwnerRequestsState extends Equatable {
  final bool loading;
  final bool submitting;
  final bool uploadingLogo; // kept for UI consistency (button spinner)
  final bool building; // kept for compatibility (not used now)
  final String? error;

  final List<Project> projects;
  final List<AppRequest> myRequests;

  final List<ThemeLite> themes;
  final int? selectedThemeId;

  /// Either a pasted URL (server-side hosted) OR a picked file path.
  final String? logoUrl;
  final String? logoFilePath; // <— NEW

  final Project? selected;
  final String appName;

  /// last server result (lightweight, best-effort)
  final AppRequest? lastCreated;

  /// If backend returns it right away
  final String? builtApkUrl;
  final String? builtAt;

  const OwnerRequestsState({
    required this.loading,
    required this.submitting,
    required this.uploadingLogo,
    required this.building,
    required this.error,
    required this.projects,
    required this.myRequests,
    required this.themes,
    required this.selectedThemeId,
    required this.logoUrl,
    required this.logoFilePath,
    required this.selected,
    required this.appName,
    required this.lastCreated,
    required this.builtApkUrl,
    required this.builtAt,
  });

  const OwnerRequestsState.initial()
      : loading = false,
        submitting = false,
        uploadingLogo = false,
        building = false,
        error = null,
        projects = const [],
        myRequests = const [],
        themes = const [],
        selectedThemeId = null,
        logoUrl = null,
        logoFilePath = null,
        selected = null,
        appName = '',
        lastCreated = null,
        builtApkUrl = null,
        builtAt = null;

  OwnerRequestsState copyWith({
    bool? loading,
    bool? submitting,
    bool? uploadingLogo,
    bool? building,
    String? error,
    List<Project>? projects,
    List<AppRequest>? myRequests,
    List<ThemeLite>? themes,
    int? selectedThemeId,
    String? logoUrl,
    String? logoFilePath,
    Project? selected,
    String? appName,
    AppRequest? lastCreated,
    String? builtApkUrl,
    String? builtAt,
  }) {
    return OwnerRequestsState(
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      uploadingLogo: uploadingLogo ?? this.uploadingLogo,
      building: building ?? this.building,
      error: error,
      projects: projects ?? this.projects,
      myRequests: myRequests ?? this.myRequests,
      themes: themes ?? this.themes,
      selectedThemeId: selectedThemeId ?? this.selectedThemeId,
      logoUrl: logoUrl ?? this.logoUrl,
      logoFilePath: logoFilePath ?? this.logoFilePath,
      selected: selected ?? this.selected,
      appName: appName ?? this.appName,
      lastCreated: lastCreated ?? this.lastCreated,
      builtApkUrl: builtApkUrl ?? this.builtApkUrl,
      builtAt: builtAt ?? this.builtAt,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        submitting,
        uploadingLogo,
        building,
        error,
        projects,
        myRequests,
        themes,
        selectedThemeId,
        logoUrl,
        logoFilePath,
        selected,
        appName,
        lastCreated,
        builtApkUrl,
        builtAt,
      ];
}
