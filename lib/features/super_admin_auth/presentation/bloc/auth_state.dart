import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool loading;
  final bool isSuperAdmin;
  final String? error;

  const AuthState({
    this.loading = false,
    this.isSuperAdmin = false,
    this.error,
  });

  AuthState copyWith({bool? loading, bool? isSuperAdmin, String? error}) {
    return AuthState(
      loading: loading ?? this.loading,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, isSuperAdmin, error];
}

const AuthInitial = AuthState();
