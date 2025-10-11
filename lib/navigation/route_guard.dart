import 'package:go_router/go_router.dart';
import '../features/super_admin_auth/data/datasources/jwt_local_datasource.dart';
import '../features/super_admin_auth/data/repositories/auth_repository_impl.dart';
import '../features/super_admin_auth/data/services/auth_api.dart';
import '../features/super_admin_auth/domain/usecases/is_super_admin_usecase.dart';

Future<String?> authRedirect(context, GoRouterState state) async {
  // quick inline wiring (can be replaced by get_it)
  final repo =
      AuthRepositoryImpl(api: AuthApi(), jwtStore: JwtLocalDataSource());
  final isSuper = await IsSuperAdminUseCase(repo).call();

  final atLogin = state.matchedLocation == '/login';
  if (!isSuper && !atLogin) return '/login';
  if (isSuper && atLogin) return '/super-admin';
  return null;
}
