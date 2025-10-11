import '../repositories/i_auth_repository.dart';

class LogoutUseCase {
  final IAuthRepository repo;
  LogoutUseCase(this.repo);
  Future<void> call() => repo.logout();
}
