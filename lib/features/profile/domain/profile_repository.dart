import 'package:money_management/features/profile/domain/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile(String uid);
  Future<UserProfile> create(String uid);
  Future<UserProfile> updateProfile(UserProfile profile);
}
