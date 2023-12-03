import 'package:money_management/features/profile/domain/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile(String uid);
  Future<UserProfile> create(String uid, String name, String email);
  Future<UserProfile> updateProfile(UserProfile profile);
  Future<List<UserProfile>> getAllUser();
}
