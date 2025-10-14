import 'package:build4all_manager/core/network/dio_client.dart';
import 'package:flutter/material.dart';

import 'package:build4all_manager/app/app.dart';
import 'package:build4all_manager/core/network/api_client.dart';
import 'package:build4all_manager/core/network/api_config.dart';
import 'package:build4all_manager/core/network/globals.dart' as g;


import 'package:build4all_manager/features/auth/data/datasources/jwt_local_datasource.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load base URL
  final config = await ApiConfig.load();

  // Single shared Dio instance
  final client = ApiClient(config);
  g.appDio = client.dio;
  g.appServerRoot = config.baseUrl;

  //  Restore token from SharedPreferences and set Authorization header
  final jwt = JwtLocalDataSource();
  final (token, _) = await jwt.read();
  if (token.isNotEmpty) {
    DioClient.setToken(token);
  }

  runApp(const Build4AllManagerApp());
}
