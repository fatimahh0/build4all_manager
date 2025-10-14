import '../entities/admin_profile.dart';
import '../repositories/i_admin_repository.dart';

class GetMe {
  final IAdminRepository repo;
  GetMe(this.repo);
  Future<AdminProfile> call() => repo.me();
}
