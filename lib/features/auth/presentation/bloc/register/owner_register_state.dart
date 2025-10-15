import 'package:equatable/equatable.dart';

class OwnerRegisterState extends Equatable {
  final bool loading;
  final String? error; // toast this on UI if present
  final String? registrationToken; // set after OTP is verified
  final bool completed; // true after profile creation success

  const OwnerRegisterState({
    this.loading = false,
    this.error,
    this.registrationToken,
    this.completed = false,
  });

  OwnerRegisterState copyWith({
    bool? loading,
    String? error,
    String? registrationToken,
    bool? completed,
  }) {
    return OwnerRegisterState(
      loading: loading ?? this.loading,
      error: error,
      registrationToken: registrationToken ?? this.registrationToken,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object?> get props => [loading, error, registrationToken, completed];
}

const OwnerRegisterInitial = OwnerRegisterState();
