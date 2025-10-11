import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/is_super_admin_usecase.dart';
import '../../domain/usecases/login_super_admin_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginSuperAdminUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final IsSuperAdminUseCase isSuperAdminUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.isSuperAdminUseCase,
  }) : super(AuthInitial) {
    on<LoginSubmitted>(_onLogin);
    on<LoggedOut>(_onLogout);
    on<CheckSession>(_onCheck);
  }

  Future<void> _onLogin(LoginSubmitted e, Emitter<AuthState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final _ = await loginUseCase(e.email, e.password);
      // we just need to know if SUPER_ADMIN
      final ok = await isSuperAdminUseCase();
      emit(state.copyWith(loading: false, isSuperAdmin: ok));
    } catch (err) {
      emit(state.copyWith(
          loading: false, error: err.toString(), isSuperAdmin: false));
    }
  }

  Future<void> _onLogout(LoggedOut e, Emitter<AuthState> emit) async {
    await logoutUseCase();
    emit(AuthInitial);
  }

  Future<void> _onCheck(CheckSession e, Emitter<AuthState> emit) async {
    final ok = await isSuperAdminUseCase();
    emit(state.copyWith(isSuperAdmin: ok));
  }
}
