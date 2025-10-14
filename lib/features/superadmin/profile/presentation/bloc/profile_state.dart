import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_profile.dart';

class ProfileState extends Equatable {
  final bool loading;
  final AdminProfile? me;
  final String? error;
  final String? success; // 👈 added
  final bool savingProfile;
  final bool savingPassword;
  final bool savingNotifications;

  const ProfileState({
    this.loading = false,
    this.me,
    this.error,
    this.success, // 👈 added
    this.savingProfile = false,
    this.savingPassword = false,
    this.savingNotifications = false,
  });

  ProfileState copyWith({
    bool? loading,
    AdminProfile? me,
    String? error,
    String? success,
    bool? savingProfile,
    bool? savingPassword,
    bool? savingNotifications,
  }) {
    return ProfileState(
      loading: loading ?? this.loading,
      me: me ?? this.me,
      error: error,
      success: success, // pass null to clear, non-null to set
      savingProfile: savingProfile ?? this.savingProfile,
      savingPassword: savingPassword ?? this.savingPassword,
      savingNotifications: savingNotifications ?? this.savingNotifications,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        me,
        error,
        success, // 👈 added
        savingProfile,
        savingPassword,
        savingNotifications
      ];
}
