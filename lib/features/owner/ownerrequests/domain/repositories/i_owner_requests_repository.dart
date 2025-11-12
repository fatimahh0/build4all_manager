import 'package:build4all_manager/features/owner/common/domain/entities/app_request.dart';


import '../entities/project.dart';
import '../entities/theme_lite.dart';

abstract class IOwnerRequestsRepository {
  Future<List<Project>> getAvailableProjects();
  Future<List<AppRequest>> getMyRequests(int ownerId);
  Future<List<ThemeLite>> getThemes();

  Future<AppRequest> createAppRequestAuto({
    required int ownerId,
    required int projectId,
    required String appName,
    int? themeId,
    String? logoUrl,
    String? slug,
    String? logoFilePath, // supports multipart upload
  });
}
