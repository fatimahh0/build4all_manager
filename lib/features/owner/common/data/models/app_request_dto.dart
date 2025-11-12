import '../../domain/entities/app_request.dart';

class AppRequestDto {
  final int id;
  final int ownerId;
  final int projectId;
  final String appName;
  final String status;
  final String createdAt;
  final String? projectName;
  final String? notes;
  final String? slug;
  final String? apkUrl;

  AppRequestDto({
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

  factory AppRequestDto.fromJson(Map<String, dynamic> j) => AppRequestDto(
        id: j['id'] as int,
        ownerId: j['ownerId'] as int,
        projectId: j['projectId'] as int,
        appName: (j['appName'] ?? '') as String,
        status: (j['status'] ?? '') as String,
        createdAt: (j['createdAt'] ?? '') as String,
        projectName: j['projectName'] as String?,
        notes: j['notes'] as String?,
        slug: j['slug'] as String?,
        apkUrl: j['apkUrl'] as String?,
      );

  AppRequest toEntity() => AppRequest(
        id: id,
        ownerId: ownerId,
        projectId: projectId,
        appName: appName,
        status: status,
        createdAt: DateTime.tryParse(createdAt) ??
            DateTime.fromMillisecondsSinceEpoch(0),
        projectName: projectName,
        notes: notes,
        slug: slug,
        apkUrl: apkUrl,
      );
}
