class OwnerProject {
  final int projectId;
  final String projectName;
  final String slug;
  final String? apkUrl;

  const OwnerProject({
    required this.projectId,
    required this.projectName,
    required this.slug,
    this.apkUrl,
  });

  bool get isApkReady => (apkUrl != null && apkUrl!.isNotEmpty);
}
