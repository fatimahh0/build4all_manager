// lib/features/owner/ownerrequests/presentation/cubit/owner_requests_cubit.dart
import 'package:build4all_manager/features/owner/ownerrequests/domain/entities/theme_lite.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_request.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/i_owner_requests_repository.dart';

part 'owner_requests_state.dart';

class OwnerRequestsCubit extends Cubit<OwnerRequestsState> {
  final IOwnerRequestsRepository repo;
  final int ownerId;

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
      final created = await repo.createAppRequestAuto(
        ownerId: ownerId,
        projectId: state.selected!.id,
        appName: state.appName.trim(),
        themeId: state.selectedThemeId,
        logoUrl: state.logoUrl,
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
