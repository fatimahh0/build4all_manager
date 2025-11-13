import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/domain/entities/app_config.dart';
import '../../../common/domain/entities/app_request.dart';
import '../../../common/domain/usecases/get_app_config_uc.dart';
import '../../../common/domain/usecases/get_my_requests_uc.dart';
import '../../domain/usecases/get_available_kinds_from_active_uc.dart';
import 'owner_home_event.dart';
import 'owner_home_state.dart';

class OwnerHomeBloc extends Bloc<OwnerHomeEvent, OwnerHomeState> {
  final GetMyRequestsUc getMyRequests;
  final GetAppConfigUc getAppConfig;
  final GetAvailableKindsFromActiveUc getAvailableKinds;

  OwnerHomeBloc({
    required this.getMyRequests,
    required this.getAppConfig,
    required this.getAvailableKinds,
  }) : super(const OwnerHomeState()) {
    on<OwnerHomeStarted>(_onLoad);
    on<OwnerHomeRefreshed>(_onLoad);
  }

  Future<void> _onLoad(OwnerHomeEvent e, Emitter<OwnerHomeState> emit) async {
    final ownerId =
        (e is OwnerHomeStarted) ? e.ownerId : (e as OwnerHomeRefreshed).ownerId;

    emit(state.copyWith(loading: true, error: null));

    try {
      final List<AppRequest> reqs = await getMyRequests(ownerId);
      reqs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      AppConfig? cfg;
      try {
        cfg = await getAppConfig();
      } catch (_) {
        cfg = null;
      }

      Set<String> kinds = state.availableKinds;
      try {
        kinds = await getAvailableKinds();
      } catch (_) {
        // if backend fails, we fallback to activities only
        kinds = {'activities'};
      }

      emit(state.copyWith(
        loading: false,
        recent: reqs.take(5).toList(),
        config: cfg,
        availableKinds: kinds,
      ));
    } catch (err) {
      emit(state.copyWith(loading: false, error: err.toString()));
    }
  }
}
