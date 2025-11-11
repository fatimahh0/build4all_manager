class AppRequest {
  final int id;
  final int ownerId;
  final int projectId;
  final String appName;
  final String? notes;
  final String status;
  final DateTime? createdAt;

  // NEW
  final String? slug;
  final String? apkUrl;

  const AppRequest({
    required this.id,
    required this.ownerId,
    required this.projectId,
    required this.appName,
    required this.status,
    this.notes,
    this.createdAt,
    this.slug, // NEW
    this.apkUrl, // NEW
  });
}
