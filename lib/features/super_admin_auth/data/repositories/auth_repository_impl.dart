import '../../domain/entities/admin_user.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/jwt_local_datasource.dart';
import '../models/admin_login_request_dto.dart';
import '../models/admin_login_response_dto.dart';
import '../services/auth_api.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthApi api;
  final JwtLocalDataSource jwtStore;

  AuthRepositoryImpl({required this.api, required this.jwtStore});

  @override
  Future<(AuthToken, AdminUser)> loginSuperAdmin({
    required String email,
    required String password,
  }) async {
    final res = await api.superAdminLogin(
      AdminLoginRequestDto(usernameOrEmail: email, password: password),
    );

    final dto =
        AdminLoginResponseDto.fromJson(res.data as Map<String, dynamic>);

    final role = (dto.admin['role'] ?? '').toString();
    final admin = AdminUser(
      id: (dto.admin['id'] as num).toInt(),
      username: (dto.admin['username'] ?? '').toString(),
      firstName: (dto.admin['firstName'] ?? '').toString(),
      lastName: (dto.admin['lastName'] ?? '').toString(),
      email: (dto.admin['email'] ?? '').toString(),
      role: role,
    );

    await jwtStore.save(token: dto.token, role: role);

    return (AuthToken(dto.token), admin);
  }

  @override
  Future<void> logout() => jwtStore.clear();

  @override
  Future<bool> isSuperAdmin() async {
    final (token, role) = await jwtStore.read();
    return token.isNotEmpty && role.toUpperCase() == 'SUPER_ADMIN';
  }
}
