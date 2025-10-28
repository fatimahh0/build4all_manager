import '../entities/app_config.dart';
import '../entities/app_request.dart';
import '../entities/owner_project.dart';

abstract class IOwnerRepository {
  Future<AppConfig> getAppConfig();
  Future<List<AppRequest>> getMyRequests({required int ownerId});
  Future<List<OwnerProject>> getMyApps({required int ownerId});
}
