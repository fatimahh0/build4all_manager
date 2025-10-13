import '../../domain/entities/project_summary.dart';

class ProjectDto {
  final int id;
  final String name;
  final String? description;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProjectDto({
    required this.id,
    required this.name,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    this.description,
  });

  factory ProjectDto.fromJson(Map<String, dynamic> j) => ProjectDto(
        id: (j['id'] as num).toInt(),
        name: j['projectName']?.toString() ?? '',
        description: j['description']?.toString(),
        active: (j['active'] ?? false) as bool,
        createdAt: DateTime.parse(j['createdAt'].toString()),
        updatedAt: DateTime.parse(j['updatedAt'].toString()),
      );

  ProjectSummary toEntity() => ProjectSummary(
        id: id,
        name: name,
        description: description,
        active: active,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
