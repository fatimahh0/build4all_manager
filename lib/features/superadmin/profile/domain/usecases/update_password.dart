import '../repositories/i_admin_repository.dart';

class UpdatePassword {
  final IAdminRepository repo;
  UpdatePassword(this.repo);
  Future<void> call(String currentPassword, String newPassword) =>
      repo.updatePassword(currentPassword, newPassword);
}
