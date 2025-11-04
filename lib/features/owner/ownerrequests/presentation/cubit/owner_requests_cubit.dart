import 'package:build4all_manager/features/owner/ownerrequests/domain/entities/theme_lite.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart'; // <— add this package
import '../../domain/entities/app_request.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/i_owner_requests_repository.dart';
import '../../data/services/owner_requests_api.dart'
    show OwnerRequestsApi; // need the concrete API
import '../../utils/slug.dart'; // the helper from step #1

part 'owner_requests_state.dart';

class OwnerRequestsCubit extends Cubit<OwnerRequestsState> {
  final IOwnerRequestsRepository repo;
  final int ownerId;

  // Access the concrete API when we need upload (you already pass the instance in the repo)
  OwnerRequestsApi? _api;
  void setConcreteApi(OwnerRequestsApi api) => _api = api;

  OwnerRequestsCubit({required this.repo, required this.ownerId})
      : super(const OwnerRequestsState.initial());

  Future<void> init() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final projects = await repo.getAvailableProjects();
      final reqs = await repo.getMyRequests(ownerId);
      final themes = await repo.getThemes();
      emit(state.copyWith(
        loading: false,
        projects: projects,
        myRequests: reqs,
        themes: themes,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void selectProject(Project? p) => emit(state.copyWith(selected: p));
  void setAppName(String v) => emit(state.copyWith(appName: v));
  void setLogoUrl(String? v) => emit(state.copyWith(logoUrl: v));
  void setThemeId(int? id) => emit(state.copyWith(selectedThemeId: id));

  /// NEW: pick a file and upload to get a logoUrl
  Future<void> pickAndUploadLogo() async {
    if (state.selected == null) {
      emit(state.copyWith(error: '_ERR_NO_PROJECT_'));
      return;
    }
    if (state.appName.trim().isEmpty) {
      emit(state.copyWith(error: '_ERR_NO_APPNAME_'));
      return;
    }
    if (_api == null) {
      emit(state.copyWith(error: 'Upload API not wired'));
      return;
    }

    // 1) pick file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: false,
    );
    if (result == null || result.files.isEmpty) return; // cancelled

    final path = result.files.single.path;
    if (path == null) {
      emit(state.copyWith(error: 'Failed to read file path'));
      return;
    }

    // 2) upload
    emit(state.copyWith(uploadingLogo: true, error: null));
    try {
      final slug =
          slugify(state.appName); // ensure same slug for both upload + create
      final resp = await _api!.uploadLogo(
        adminId: ownerId, // in your model, admin == owner
        projectId: state.selected!.id,
        slug: slug,
        filePath: path,
      );
      final logoUrl = resp['logoUrl'];
      emit(state.copyWith(uploadingLogo: false, logoUrl: logoUrl));
    } catch (e) {
      emit(state.copyWith(uploadingLogo: false, error: e.toString()));
    }
  }

  Future<void> submitAuto() async {
    if (state.selected == null) {
      emit(state.copyWith(error: '_ERR_NO_PROJECT_'));
      return;
    }
    if (state.appName.trim().isEmpty) {
      emit(state.copyWith(error: '_ERR_NO_APPNAME_'));
      return;
    }

    emit(state.copyWith(submitting: true, error: null));
    try {
      // IMPORTANT: send the exact slug we used during upload (so backend paths match)
      final created = await repo.createAppRequestAuto(
        ownerId: ownerId,
        projectId: state.selected!.id,
        appName: state.appName.trim(),
        themeId: state.selectedThemeId,
        logoUrl: state.logoUrl,
        slug: slugify(state.appName), // <— NEW
      );
      final reqs = await repo.getMyRequests(ownerId);
      emit(state.copyWith(
        submitting: false,
        myRequests: reqs,
        lastCreated: created,
        selected: null,
        appName: '',
        logoUrl: null,
        selectedThemeId: null,
      ));
    } catch (e) {
      emit(state.copyWith(submitting: false, error: e.toString()));
    }
  }
}
