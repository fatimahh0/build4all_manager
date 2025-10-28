
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

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final projects = await repo.getAvailableProjects();
      final reqs = await repo.getMyRequests(ownerId);
      emit(state.copyWith(loading: false, projects: projects, myRequests: reqs));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void selectProject(Project? p) => emit(state.copyWith(selected: p));
  void setAppName(String v) => emit(state.copyWith(appName: v));
  void setThemeChoice(String? v) => emit(state.copyWith(themeChoice: v));

  Future<void> submit() async {
    if (state.selected == null || state.appName.trim().isEmpty) {
      emit(state.copyWith(error: 'Select a project and enter an app name.'));
      return;
    }
    emit(state.copyWith(submitting: true, error: null));
    try {
      final notes = (state.themeChoice ?? '').isEmpty
          ? null
          : 'theme=${state.themeChoice}';
      final created = await repo.createAppRequest(
        ownerId: ownerId,
        projectId: state.selected!.id,
        appName: state.appName.trim(),
        notes: notes,
      );
      final reqs = await repo.getMyRequests(ownerId);
      emit(state.copyWith(
        submitting: false,
        myRequests: reqs,
        lastCreated: created,
        selected: null,
        appName: '',
        themeChoice: null,
      ));
    } catch (e) {
      emit(state.copyWith(submitting: false, error: e.toString()));
    }
  }
}
