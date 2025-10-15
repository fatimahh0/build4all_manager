import 'package:build4all_manager/features/auth/domain/repositories/i_auth_repository.dart';

class OwnerSendOtpUseCase {
  final IAuthRepository repo;
  OwnerSendOtpUseCase(this.repo);
  Future<void> call(String email, String password) =>
      repo.ownerSendOtp(email: email, password: password);
}
