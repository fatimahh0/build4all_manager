import 'package:flutter/material.dart';

import 'package:build4all_manager/app/app.dart';
import 'package:build4all_manager/core/network/api_client.dart';
import 'package:build4all_manager/core/network/api_config.dart';
import 'package:build4all_manager/core/network/globals.dart' as g;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load base URL (handles prefs/dart-define inside)
  final config = await ApiConfig.load();

  // Single shared Dio instance
  final client = ApiClient(config);
  g.appDio = client.dio;
  g.appServerRoot = config.baseUrl;

  runApp(const Build4AllManagerApp());
}
