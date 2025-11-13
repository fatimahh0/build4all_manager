class BackendProject {
  final int id;
  final String name;
  final String description;
  final bool active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BackendProject({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
    this.createdAt,
    this.updatedAt,
  });
}
