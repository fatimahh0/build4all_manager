import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'jwt_store.dart';

class DioClient {
  DioClient._();
  static Dio? _dio;

  static Dio ensure() {
    if (_dio != null) return _dio!;
    final d = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {'Accept': 'application/json'},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
    ));

    d.interceptors.add(InterceptorsWrapper(onRequest: (o, h) async {
      final t = (await JwtStore.read()).trim();
      if (t.isNotEmpty && !o.headers.containsKey('Authorization')) {
        o.headers['Authorization'] = t.startsWith('Bearer ') ? t : 'Bearer $t';
      }
      h.next(o);
    }));

    _dio = d;
    return d;
  }
}
