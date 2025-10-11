class AdminLoginRequestDto {
  final String usernameOrEmail; // your backend uses this key
  final String password;

  AdminLoginRequestDto({required this.usernameOrEmail, required this.password});

  Map<String, dynamic> toJson() => {
        'usernameOrEmail': usernameOrEmail,
        'password': password,
      };
}
