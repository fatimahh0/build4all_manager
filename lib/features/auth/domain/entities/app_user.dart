class AppUser {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String role; // e.g., SUPER_ADMIN, USER, BUSINESS, MANAGER

  const AppUser({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });
}
