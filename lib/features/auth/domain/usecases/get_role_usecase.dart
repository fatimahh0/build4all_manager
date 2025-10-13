import '../repositories/i_auth_repository.dart';

class GetStoredRoleUseCase {
  final IAuthRepository repo;
  GetStoredRoleUseCase(this.repo);
  Future<String> call() => repo.getStoredRole();
}
