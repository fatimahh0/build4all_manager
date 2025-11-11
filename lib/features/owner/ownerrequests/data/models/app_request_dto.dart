class AppRequestDto {
  final int id;
  final int ownerId;
  final int projectId;
  final String appName;
  final String? notes;
  final String status;
  final DateTime? createdAt;

  // NEW:
  final String? slug;
  final String? apkUrl;

  AppRequestDto({
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

  factory AppRequestDto.fromJson(Map<String, dynamic> j) => AppRequestDto(
        id: (j['id'] ?? 0) as int,
        ownerId:
            (j['ownerId'] ?? j['adminId'] ?? 0) as int, // tolerate adminId name
        projectId: (j['projectId'] ?? 0) as int,
        appName: (j['appName'] ?? '').toString(),
        notes: j['notes']?.toString(),
        status: (j['status'] ?? '').toString(),
        createdAt: j['createdAt'] == null
            ? null
            : DateTime.tryParse(j['createdAt'].toString()),

        // NEW (present in your response payload)
        slug: j['slug']?.toString(),
        apkUrl: j['apkUrl']?.toString(),
      );

  static List<AppRequestDto> list(dynamic data) {
    if (data is List) {
      return data
          .map((e) => AppRequestDto.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return const [];
  }
}
