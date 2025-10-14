import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_profile.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class RefreshProfile extends ProfileEvent {}

class SubmitProfile extends ProfileEvent {
  final AdminProfile profile;
  SubmitProfile(this.profile);
  @override
  List<Object?> get props => [profile];
}

class SubmitPassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;
  SubmitPassword(this.currentPassword, this.newPassword);
  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class SubmitNotifications extends ProfileEvent {
  final bool notifyItems;
  final bool notifyFeedback;
  SubmitNotifications(this.notifyItems, this.notifyFeedback);
  @override
  List<Object?> get props => [notifyItems, notifyFeedback];
}
