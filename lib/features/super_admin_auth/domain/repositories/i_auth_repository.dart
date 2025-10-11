import '../entities/admin_user.dart';
import '../entities/auth_token.dart';

abstract class IAuthRepository {
  Future<(AuthToken, AdminUser)> loginSuperAdmin({
    required String email,
    required String password,
  });

  Future<void> logout();

  /// read persisted token+role and verify it’s a super admin
  Future<bool> isSuperAdmin();
}
