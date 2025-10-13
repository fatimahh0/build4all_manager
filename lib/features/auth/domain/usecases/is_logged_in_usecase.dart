import '../repositories/i_auth_repository.dart';

class IsLoggedInUseCase {
  final IAuthRepository repo;
  IsLoggedInUseCase(this.repo);
  Future<bool> call() => repo.isLoggedIn();
}
