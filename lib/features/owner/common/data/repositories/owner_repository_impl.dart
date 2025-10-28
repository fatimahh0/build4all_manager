import '../../domain/entities/app_config.dart';
import '../../domain/entities/app_request.dart';
import '../../domain/entities/owner_project.dart';
import '../../domain/repositories/i_owner_repository.dart';
import '../services/owner_api.dart';

class OwnerRepositoryImpl implements IOwnerRepository {
  final OwnerApi api;
  OwnerRepositoryImpl(this.api);

  @override
  Future<AppConfig> getAppConfig() async {
    final dto = await api.getAppConfig();
    return dto.toEntity();
  }

  @override
  Future<List<AppRequest>> getMyRequests({required int ownerId}) async {
    final dtos = await api.getMyRequests(ownerId: ownerId);
    return dtos.map((d) => d.toEntity()).toList();
  }

  @override
  Future<List<OwnerProject>> getMyApps({required int ownerId}) async {
    final dtos = await api.getMyApps(ownerId: ownerId);
    return dtos.map((d) => d.toEntity()).toList();
  }
}
