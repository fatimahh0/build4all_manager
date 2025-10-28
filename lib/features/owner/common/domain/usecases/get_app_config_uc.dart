import '../entities/app_config.dart';
import '../repositories/i_owner_repository.dart';

class GetAppConfigUc {
  final IOwnerRepository repo;
  GetAppConfigUc(this.repo);
  Future<AppConfig> call() => repo.getAppConfig();
}
