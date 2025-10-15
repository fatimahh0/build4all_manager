import '../entities/app_user.dart';
import '../entities/auth_token.dart';
import '../repositories/i_auth_repository.dart';

class LoginUseCase {
  final IAuthRepository repo;
  LoginUseCase(this.repo);
  Future<(AuthToken, AppUser)> call(String id, String pw) =>
      repo.login(identifier: id, password: pw);
}
