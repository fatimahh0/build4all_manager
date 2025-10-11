class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_ROOT',
    defaultValue: 'http://192.168.1.6:8080',
  );

  // Auth
  static const login = '/api/auth/login';
  static const me = '/api/auth/me';

  // Super Admin
  static const themeGet = '/api/admin/themes/current';
  static const themeSave = '/api/admin/themes';
  static const projects = '/api/admin/projects'; // GET list, POST create
}
