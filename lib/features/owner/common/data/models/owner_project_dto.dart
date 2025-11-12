import '../../domain/entities/owner_project.dart';

class OwnerProjectDto {
  final int projectId;
  final String projectName;
  final String slug;
  final String? apkUrl;

  OwnerProjectDto({
    required this.projectId,
    required this.projectName,
    required this.slug,
    this.apkUrl,
  });

  factory OwnerProjectDto.fromJson(Map<String, dynamic> j) => OwnerProjectDto(
        projectId: j['projectId'] ?? 0,
        projectName: (j['projectName'] ?? '').toString(),
        slug: (j['slug'] ?? '').toString(),
        apkUrl: j['apkUrl']?.toString(),
      );

  OwnerProject toEntity() => OwnerProject(
        projectId: projectId,
        projectName: projectName,
        slug: slug,
        apkUrl: apkUrl,
      );
}
