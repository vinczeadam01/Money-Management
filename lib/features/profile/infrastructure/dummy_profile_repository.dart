import 'package:money_management/features/profile/domain/profile_repository.dart';
import 'package:money_management/features/profile/domain/user_profile.dart';

class DummyProfileRepository extends ProfileRepository {
  @override
  Future<UserProfile> getProfile(String uid) async {
    return const UserProfile(
      uid: '1',
      phone: '+36301234567',

    );
  }

  @override
  Future<UserProfile> create(String uid) async {
    return UserProfile(uid: uid, phone: '');
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    return profile;
  }
}
