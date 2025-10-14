import '../entities/admin_profile.dart';
import '../repositories/i_admin_repository.dart';

class UpdateProfile {
  final IAdminRepository repo;
  UpdateProfile(this.repo);
  Future<void> call(AdminProfile profile) => repo.updateProfile(profile);
}
