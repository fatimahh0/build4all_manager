import 'package:dio/dio.dart';
import '../../../../config/api_config.dart';
import '../../../../core/dio_client.dart';
import '../models/admin_login_request_dto.dart';

class AuthApi {
  final Dio _dio = DioClient.ensure();

  Future<Response<dynamic>> superAdminLogin(AdminLoginRequestDto body) {
    return _dio.post(
      '${ApiConfig.baseUrl}/api/auth/superadmin/login',
      data: body.toJson(),
    );
  }
}
