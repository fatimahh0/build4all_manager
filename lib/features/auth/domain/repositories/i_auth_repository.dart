import '../entities/app_user.dart';
import '../entities/auth_token.dart';

abstract class IAuthRepository {
  Future<(AuthToken, AppUser)> login({
    required String identifier, // email or username
    required String password,
  });

  Future<void> logout();

  Future<bool> isLoggedIn();
  Future<String> getStoredRole(); // raw role
  Future<bool> isSuperAdmin(); // convenience
}
