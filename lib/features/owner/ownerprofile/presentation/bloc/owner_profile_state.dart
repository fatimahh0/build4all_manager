import 'package:build4all_manager/features/owner/ownerprofile/domain/entities/owner_profile.dart';
import 'package:equatable/equatable.dart';


class OwnerProfileState extends Equatable {
  final bool loading;
  final String? error;
  final OwnerProfile? profile;

  const OwnerProfileState({required this.loading, this.error, this.profile});

  const OwnerProfileState.initial()
      : loading = false,
        error = null,
        profile = null;

  OwnerProfileState copyWith(
      {bool? loading, String? error, OwnerProfile? profile}) {
    return OwnerProfileState(
      loading: loading ?? this.loading,
      error: error,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [loading, error, profile];
}
