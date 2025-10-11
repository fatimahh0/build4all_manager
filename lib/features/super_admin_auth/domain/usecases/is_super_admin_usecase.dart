import '../repositories/i_auth_repository.dart';

class IsSuperAdminUseCase {
  final IAuthRepository repo;
  IsSuperAdminUseCase(this.repo);
  Future<bool> call() => repo.isSuperAdmin();
}
