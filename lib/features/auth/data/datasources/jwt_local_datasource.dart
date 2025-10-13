import 'package:shared_preferences/shared_preferences.dart';

class JwtLocalDataSource {
  static const _kToken = 'auth_jwt';
  static const _kRole = 'auth_role';

  Future<void> save({required String token, required String role}) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kToken, token.trim());
    await p.setString(_kRole, role.trim());
  }

  Future<(String token, String role)> read() async {
    final p = await SharedPreferences.getInstance();
    return (p.getString(_kToken) ?? '', p.getString(_kRole) ?? '');
  }

  Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kToken);
    await p.remove(_kRole);
  }
}
