class AdminLoginResponseDto {
  final String token;
  final Map<String, dynamic> admin;

  AdminLoginResponseDto({required this.token, required this.admin});

  factory AdminLoginResponseDto.fromJson(Map<String, dynamic> json) {
    return AdminLoginResponseDto(
      token: (json['token'] ?? '').toString(),
      admin: (json['admin'] ?? {}) as Map<String, dynamic>,
    );
  }
}
