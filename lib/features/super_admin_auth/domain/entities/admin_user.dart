class AdminUser {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String role; // expected "SUPER_ADMIN"

  const AdminUser({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });
}
