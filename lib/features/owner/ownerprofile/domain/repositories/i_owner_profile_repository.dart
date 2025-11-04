import '../entities/owner_profile.dart';

abstract class IOwnerProfileRepository {
  Future<OwnerProfile> getMe();
  Future<OwnerProfile> getById(int adminId);
}
