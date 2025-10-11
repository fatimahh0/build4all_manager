import '../entities/admin_user.dart';
import '../entities/auth_token.dart';
import '../repositories/i_auth_repository.dart';

class LoginSuperAdminUseCase {
  final IAuthRepository repo;
  LoginSuperAdminUseCase(this.repo);

  Future<(AuthToken, AdminUser)> call(String email, String password) {
    return repo.loginSuperAdmin(email: email, password: password);
  }
}
