import 'package:dio/dio.dart';
import 'package:build4all_manager/core/network/dio_client.dart';
import '../models/login_request_dto.dart';

class AuthApi {
  final Dio _dio = DioClient.ensure();

  // Use the universal endpoint (backend should accept any role here)
  Future<Response> login(LoginRequestDto body) {
    return _dio.post('/auth/superadmin/login', data: body.toJson());
  }

  // (Optional) If your backend still has a super-admin only endpoint,
  // you can keep it as a fallback:
  Future<Response> superAdminLogin(LoginRequestDto body) {
    // IMPORTANT: no leading spaces!
    return _dio.post('/auth/superadmin/login', data: body.toJson());
  }
}
