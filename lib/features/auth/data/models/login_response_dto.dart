class LoginResponseDto {
  final String token;
  final Map<String, dynamic> userOrAdmin; // backend returns user/admin object

  LoginResponseDto({required this.token, required this.userOrAdmin});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    // supports either {"token": "...", "admin": {...}} or {"token": "...", "user": {...}}
    final map = (json['admin'] ?? json['user'] ?? {}) as Map<String, dynamic>;
    return LoginResponseDto(
      token: (json['token'] ?? '').toString(),
      userOrAdmin: map,
    );
  }
}
