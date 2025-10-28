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
        projectId: j['projectId'],
        projectName: j['projectName'],
        slug: j['slug'],
        apkUrl: j['apkUrl'],
      );

  OwnerProject toEntity() => OwnerProject(
        projectId: projectId,
        projectName: projectName,
        slug: slug,
        apkUrl: apkUrl,
      );
}
