// lib/features/superadmin/profile/data/services/admin_api.dart
import 'package:dio/dio.dart';
import 'package:build4all_manager/core/network/globals.dart' as g;

/// NOTE:
/// g.appServerRoot should already be like: http://HOST:PORT/api
/// Example final URLs:
/// - GET    {root}/superadmin/me
/// - PUT    {root}/superadmin/profile
/// - PUT    {root}/superadmin/password
/// - PUT    {root}/superadmin/notifications
class AdminApi {
  final Dio _dio;
  AdminApi(this._dio);

  String get _base => g.appServerRoot;

  // ---------- Helpers ----------

  Never _throw(Response res) {
    final msg = _extractError(res);
    throw DioException(
      requestOptions: res.requestOptions,
      response: res,
      type: DioExceptionType.badResponse,
      error: msg,
    );
  }

  String _extractError(Response res) {
    final data = res.data;
    if (data is Map) {
      final e = data['error'] ?? data['message'];
      if (e is String && e.trim().isNotEmpty) return e;
    }
    if (data is String && data.trim().isNotEmpty) return data;
    return 'HTTP ${res.statusCode ?? '???'}';
  }

  bool _isOk(Response res) {
    final code = res.statusCode ?? 0;
    // accept 200–299 and 204 (no content)
    return code >= 200 && code < 300;
  }

  // ---------- Endpoints ----------

  /// Returns the raw response (JSON). Caller can map it to a model.
  Future<Response> getMe() async {
    final res = await _dio.get('$_base/superadmin/me');
    if (!_isOk(res)) _throw(res);
    return res;
  }

  /// Updates profile. Backend often returns 200 (text) or 204 (no content).
  /// We force ResponseType.plain to avoid JSON-decode crashes.
  Future<void> updateProfile(Map<String, dynamic> body) async {
    final res = await _dio.put(
      '$_base/superadmin/profile',
      data: body,
      options: Options(
        headers: const {'Content-Type': 'application/json'},
        responseType: ResponseType.plain, // <-- important
      ),
    );
    if (!_isOk(res)) _throw(res);
  }

  /// Changes password. Same plain/empty response handling.
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final res = await _dio.put(
      '$_base/superadmin/password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
      options: Options(
        headers: const {'Content-Type': 'application/json'},
        responseType: ResponseType.plain, // <-- important
      ),
    );
    if (!_isOk(res)) _throw(res);
  }

  /// Updates notification settings (likely 200 text / 204 empty).
  Future<void> updateNotifications(Map<String, dynamic> body) async {
    final res = await _dio.put(
      '$_base/superadmin/notifications',
      data: body,
      options: Options(
        headers: const {'Content-Type': 'application/json'},
        responseType: ResponseType.plain, // <-- important
      ),
    );
    if (!_isOk(res)) _throw(res);
  }
}
