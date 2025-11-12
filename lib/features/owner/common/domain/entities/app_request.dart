class AppRequest {
  final int id;
  final int ownerId;
  final int projectId;
  final String appName;
  final String
      status; // PENDING | IN_PRODUCTION | DELIVERED | REJECTED | APPROVED
  final DateTime createdAt;

  // Optional display/extras
  final String? projectName;
  final String? notes;
  final String? slug;
  final String? apkUrl;

  const AppRequest({
    required this.id,
    required this.ownerId,
    required this.projectId,
    required this.appName,
    required this.status,
    required this.createdAt,
    this.projectName,
    this.notes,
    this.slug,
    this.apkUrl,
  });
}
