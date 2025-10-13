class LoginRequestDto {
  final String usernameOrEmail;
  final String password;

  LoginRequestDto({required this.usernameOrEmail, required this.password});

  Map<String, dynamic> toJson() => {
        'usernameOrEmail': usernameOrEmail,
        'password': password,
      };
}
