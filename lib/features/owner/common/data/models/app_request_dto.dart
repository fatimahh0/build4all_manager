import '../../domain/entities/app_request.dart';

class AppRequestDto {
  final int id;
  final String appName;
  final String projectName;
  final String status;
  final String createdAt;
  final String? notes;

  AppRequestDto({
    required this.id,
    required this.appName,
    required this.projectName,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  factory AppRequestDto.fromJson(Map<String, dynamic> j) => AppRequestDto(
        id: j['id'],
        appName: j['appName'],
        projectName: j['projectName'],
        status: j['status'],
        createdAt: j['createdAt'],
        notes: j['notes'],
      );

  AppRequest toEntity() => AppRequest(
        id: id,
        appName: appName,
        projectName: projectName,
        status: status,
        createdAt: DateTime.parse(createdAt),
        notes: notes,
      );
}
