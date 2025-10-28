class AppRequest {
  final int id;
  final String appName;
  final String projectName;
  final String status; // PENDING | APPROVED | REJECTED
  final DateTime createdAt;
  final String? notes;

  const AppRequest({
    required this.id,
    required this.appName,
    required this.projectName,
    required this.status,
    required this.createdAt,
    this.notes,
  });
}
