import 'package:money_management/features/profile/domain/profile_repository.dart';
import 'package:money_management/features/profile/domain/user_profile.dart';

class DummyProfileRepository extends ProfileRepository {
  @override
  Future<UserProfile> getProfile(String uid) async {
    return const UserProfile(
      uid: '1',
      name: 'John Doe',
      email: 'john.doe@mail.com',
      phone: '081234567890',
    );
  }

  @override
  Future<UserProfile> create(String uid, String name, String email) async {
    return UserProfile(
      uid: uid,
      name: name,
      email: email, 
      phone: '');
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    return profile;
  }
}
