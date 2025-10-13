import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool loading;
  final String? role; // null => not logged in yet
  final String? error;

  const AuthState({this.loading = false, this.role, this.error});

  AuthState copyWith({bool? loading, String? role, String? error}) {
    return AuthState(
      loading: loading ?? this.loading,
      role: role ?? this.role,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, role, error];
}

const AuthInitial = AuthState();
