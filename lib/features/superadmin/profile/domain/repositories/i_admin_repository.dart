import '../entities/admin_profile.dart';

abstract class IAdminRepository {
  Future<AdminProfile> me();
  Future<void> updateProfile(AdminProfile profile); // only editable fields
  Future<void> updatePassword(String currentPassword, String newPassword);
  Future<void> updateNotifications({
    required bool notifyItemUpdates,
    required bool notifyUserFeedback,
  });
}
