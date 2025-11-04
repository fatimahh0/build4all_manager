import '../entities/owner_profile.dart';
import '../repositories/i_owner_profile_repository.dart';

class GetOwnerProfileUseCase {
  final IOwnerProfileRepository repo;
  GetOwnerProfileUseCase(this.repo);

  Future<OwnerProfile> call({int? adminId}) {
    if (adminId == null) return repo.getMe();
    return repo.getById(adminId);
  }
}
