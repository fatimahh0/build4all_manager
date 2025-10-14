import '../repositories/i_admin_repository.dart';

class UpdateNotifications {
  final IAdminRepository repo;
  UpdateNotifications(this.repo);
  Future<void> call({required bool items, required bool feedback}) =>
      repo.updateNotifications(
        notifyItemUpdates: items,
        notifyUserFeedback: feedback,
      );
}
