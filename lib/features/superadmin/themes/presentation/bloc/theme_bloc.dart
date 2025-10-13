import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/theme_entity.dart';
import '../../domain/repositories/i_theme_repository.dart';
import '../../domain/usecases/get_all_themes.dart';
import '../../domain/usecases/get_active_theme.dart';
import '../../domain/usecases/create_theme.dart';
import '../../domain/usecases/update_theme.dart';
import '../../domain/usecases/delete_theme.dart';
import '../../domain/usecases/set_active_theme.dart';
import '../../domain/usecases/set_menu_type.dart';
import '../../domain/usecases/deactivate_all_themes.dart';
import 'theme_event.dart';
import 'theme_state.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetAllThemes getAll;
  final GetActiveTheme getActive;
  final CreateTheme create;
  final UpdateTheme update;
  final DeleteTheme deleteU;
  final SetActiveTheme setActive;
  final SetMenuType setMenuType;
  final DeactivateAllThemes deactivateAll; // ← use case stays the same

  ThemeBloc(IThemeRepository repo)
      : getAll = GetAllThemes(repo),
        getActive = GetActiveTheme(repo),
        create = CreateTheme(repo),
        update = UpdateTheme(repo),
        deleteU = DeleteTheme(repo),
        setActive = SetActiveTheme(repo),
        setMenuType = SetMenuType(repo),
        deactivateAll = DeactivateAllThemes(repo), // ← use case ctor
        super(const ThemeState()) {
    on<LoadThemes>(_load);
    on<RefreshThemes>(_load);
    on<CreateThemeEvent>(_create);
    on<UpdateThemeEvent>(_update);
    on<DeleteThemeEvent>(_delete);
    on<SetActiveThemeEvent>(_setActive);
    on<SetMenuTypeEvent>(_setMenu);
    on<DeactivateAllThemesEvent>(_deactivateAll); // ← updated event type
  }

  Future<void> _deactivateAll(
      DeactivateAllThemesEvent e, Emitter<ThemeState> emit) async {
    // ← updated
    try {
      await deactivateAll(); // ← calls the use case instance
      add(LoadThemes());
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> _load(ThemeEvent e, Emitter<ThemeState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final items = await getAll();
      final active = await getActive();
      emit(ThemeState(
        loading: false,
        items: items,
        activeId: active?.id,
      ));
    } catch (err) {
      emit(state.copyWith(loading: false, error: err.toString()));
    }
  }

  Future<void> _create(CreateThemeEvent e, Emitter<ThemeState> emit) async {
    try {
      await create(e.body);
      add(LoadThemes());
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> _update(UpdateThemeEvent e, Emitter<ThemeState> emit) async {
    try {
      await update(e.id, e.body);
      add(LoadThemes());
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> _delete(DeleteThemeEvent e, Emitter<ThemeState> emit) async {
    try {
      await deleteU(e.id);
      add(LoadThemes());
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> _setActive(
      SetActiveThemeEvent e, Emitter<ThemeState> emit) async {
    try {
      await setActive(e.id);
      add(LoadThemes());
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> _setMenu(SetMenuTypeEvent e, Emitter<ThemeState> emit) async {
    try {
      await setMenuType(e.id, e.menuType);
      // Optimistic update:
      final updated = state.items.map((t) {
        if (t.id == e.id) return t.copyWith(menuType: e.menuType);
        return t;
      }).toList();
      emit(state.copyWith(items: updated));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }


}
