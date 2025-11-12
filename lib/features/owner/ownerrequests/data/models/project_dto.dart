class ProjectDto {
  final int id;
  final String projectName;
  final String? description;
  final bool? active;

  ProjectDto({
    required this.id,
    required this.projectName,
    this.description,
    this.active,
  });

  factory ProjectDto.fromJson(Map<String, dynamic> j) => ProjectDto(
        id: (j['id'] ?? 0) as int,
        projectName: (j['projectName'] ?? '').toString(),
        description: j['description']?.toString(),
        active: j['active'] == null ? null : j['active'] as bool,
      );

  static List<ProjectDto> list(dynamic data) {
    if (data is List) {
      return data
          .map((e) => ProjectDto.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return const [];
  }
}
