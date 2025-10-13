// lib/core/config/dio_client.dart
import 'package:dio/dio.dart';
import 'package:build4all_manager/core/network/api_config.dart';
import 'package:build4all_manager/core/network/globals.dart' as g;
import 'package:build4all_manager/core/network/api_client.dart';

class DioClient {
  /// Call once in main() to set up the shared Dio from JSON config.
  static Future<void> init() async {
    final cfg = await ApiConfig.load();
    g.appServerRoot = cfg.baseUrl;
    final client = ApiClient(cfg);
    g.appDio = client.dio;
  }

  /// Get the shared Dio or throw if init() wasn't called.
  static Dio ensure() {
    final dio = g.appDio;
    if (dio == null) {
      throw StateError(
          'Dio not initialized. Call DioClient.init() in main() first.');
    }
    return dio;
  }

  /// Optional helper to update bearer token globally.
  static void setToken(String token) {
    ensure().options.headers['Authorization'] = 'Bearer $token';
    // keep legacy globals in sync if you still read them elsewhere:
    g.authToken = token;
  }
}
