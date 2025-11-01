// lib/features/owner/ownerrequests/domain/entities/app_request.dart
class AppRequest {
  final int id;
  final int ownerId;
  final int projectId;
  final String appName;
  final String? notes;
  final String status; // PENDING / APPROVED / REJECTED / STARTED
  final DateTime? createdAt;

  const AppRequest({
    required this.id,
    required this.ownerId,
    required this.projectId,
    required this.appName,
    required this.status,
    this.notes,
    this.createdAt,
  });
}
