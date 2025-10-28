class Project {
  final int id;
  final String name;
  final String? description;
  final bool? active;

  const Project({
    required this.id,
    required this.name,
    this.description,
    this.active,
  });
}
