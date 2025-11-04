import 'package:build4all_manager/features/owner/ownerrequests/domain/entities/theme_lite.dart';

import '../entities/app_request.dart';
import '../entities/project.dart';

abstract class IOwnerRequestsRepository {
  Future<List<Project>> getAvailableProjects();
  Future<List<AppRequest>> getMyRequests(int ownerId);

  /// Themes shown in the picker
  Future<List<ThemeLite>> getThemes();

  /// Auto-approve endpoint: POST /owner/app-requests/auto?ownerId=...
  Future<AppRequest> createAppRequestAuto({
    required int ownerId,
    required int projectId,
    required String appName,
    int? themeId,
    String? logoUrl,
    String? slug, // 👈 ADD THIS
  });
}
