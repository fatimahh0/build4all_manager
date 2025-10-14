class AdminProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final bool notifyItemUpdates;
  final bool notifyUserFeedback;

  const AdminProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.notifyItemUpdates,
    required this.notifyUserFeedback,
  });

  AdminProfile copyWith({
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    bool? notifyItemUpdates,
    bool? notifyUserFeedback,
  }) {
    return AdminProfile(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      notifyItemUpdates: notifyItemUpdates ?? this.notifyItemUpdates,
      notifyUserFeedback: notifyUserFeedback ?? this.notifyUserFeedback,
    );
  }
}
