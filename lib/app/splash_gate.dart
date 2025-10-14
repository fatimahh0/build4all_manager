import 'package:build4all_manager/core/network/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:build4all_manager/features/auth/data/datasources/jwt_local_datasource.dart';

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final store = JwtLocalDataSource();
    final (token, role) = await store.read();

    if (token.isNotEmpty) {
      // attach token globally
      DioClient.setToken(token);

 
      final r = (role).toUpperCase();
      if (!mounted) return;
      if (r == 'SUPER_ADMIN') {
        context.go('/manager'); 
      } else {
        context.go('/home'); 
      }
    } else {
      if (!mounted) return;
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: const CircularProgressIndicator(strokeWidth: 2.6),
        ),
      ),
    );
  }
}
