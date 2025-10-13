import '../../domain/entities/app_user.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/jwt_local_datasource.dart';
import '../models/login_request_dto.dart';
import '../models/login_response_dto.dart';
import '../services/auth_api.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthApi api;
  final JwtLocalDataSource jwtStore;
  AuthRepositoryImpl({required this.api, required this.jwtStore});

  @override
  Future<(AuthToken, AppUser)> login({
    required String identifier,
    required String password,
  }) async {
    final res = await api.login(
      LoginRequestDto(usernameOrEmail: identifier, password: password),
    );

    final dto = LoginResponseDto.fromJson(res.data as Map<String, dynamic>);
    final role = (dto.userOrAdmin['role'] ?? '').toString();

    final user = AppUser(
      id: (dto.userOrAdmin['id'] as num?)?.toInt() ?? 0,
      username: (dto.userOrAdmin['username'] ?? '').toString(),
      firstName: (dto.userOrAdmin['firstName'] ?? '').toString(),
      lastName: (dto.userOrAdmin['lastName'] ?? '').toString(),
      email: (dto.userOrAdmin['email'] ?? '').toString(),
      role: role,
    );

    await jwtStore.save(token: dto.token, role: role);
    return (AuthToken(dto.token), user);
  }

  @override
  Future<void> logout() => jwtStore.clear();

  @override
  Future<bool> isLoggedIn() async {
    final (t, _) = await jwtStore.read();
    return t.isNotEmpty;
  }

  @override
  Future<String> getStoredRole() async {
    final (_, r) = await jwtStore.read();
    return r.trim();
  }

  @override
  Future<bool> isSuperAdmin() async {
    final role = (await getStoredRole()).toUpperCase();
    return role == 'SUPER_ADMIN';
  }
}
