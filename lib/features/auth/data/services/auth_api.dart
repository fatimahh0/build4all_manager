import 'package:dio/dio.dart';
import 'package:build4all_manager/core/network/dio_client.dart';
import '../models/login_request_dto.dart';

class AuthApi {
  final Dio _dio = DioClient.ensure();

  /// ✅ unified admin login for SUPER_ADMIN / OWNER / MANAGER
  Future<Response> login(LoginRequestDto body) {
    return _dio.post('/auth/admin/login', data: body.toJson());
  }

  /// ✅ OWNER email-OTP registration (3 steps)
  Future<Response> ownerSendOtp({
    required String email,
    required String password, // temporarily passed to backend step 2
  }) {
    return _dio.post('/auth/owner/send-verification-email', queryParameters: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> ownerVerifyOtp({
    required String email,
    required String password,
    required String code,
  }) {
    return _dio.post('/auth/owner/verify-email-code', data: {
      'email': email,
      'password': password,
      'code': code,
    });
  }

  Future<Response> ownerCompleteProfile({
    required String registrationToken,
    required String username,
    required String firstName,
    required String lastName,
  }) {
    return _dio.post('/auth/owner/complete-profile', data: {
      'registrationToken': registrationToken,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
    });
  }
}
