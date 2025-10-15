import 'package:build4all_manager/features/auth/domain/repositories/i_auth_repository.dart';

class OwnerVerifyOtpUseCase {
  final IAuthRepository repo;
  OwnerVerifyOtpUseCase(this.repo);
  Future<String> call(String email, String password, String code) =>
      repo.ownerVerifyOtp(email: email, password: password, code: code);
}
