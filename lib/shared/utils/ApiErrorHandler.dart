import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String message(Object error) {
    if (error is DioException) {
      final res = error.response;
      if (res?.data is Map) {
        final m = res!.data as Map;
        // backend often sends {message: "..."} or {error: "..."}
        final v = (m['message'] ?? m['error'] ?? '').toString();
        if (v.isNotEmpty) return v;
      }
      // fallbacks
      return res?.statusMessage ??
          error.message ??
          'Network error (${error.type.name})';
    }
    return error.toString();
  }
}
