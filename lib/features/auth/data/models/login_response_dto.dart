class LoginResponseDto {
  final String token;
  final Map<String, dynamic> userOrAdmin;
  final String role;

  LoginResponseDto({
    required this.token,
    required this.userOrAdmin,
    required this.role,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    // backend shapes:
    // {token, role, admin:{...}}  OR  {token, role, user:{...}}
    final map = (json['admin'] ?? json['user'] ?? {}) as Map<String, dynamic>;
    final role = (json['role'] ?? map['role'] ?? '').toString();
    return LoginResponseDto(
      token: (json['token'] ?? '').toString(),
      userOrAdmin: map,
      role: role,
    );
  }
}
