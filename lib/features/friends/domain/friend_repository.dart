import 'package:money_management/features/profile/domain/user_profile.dart';

abstract class FriendRepository {
  Future<List<UserProfile>> getFriends(String uid);
  Future<void> addFriend(String currentUserId, String friendId);
  Future<void> removeFriend(String currentUserId, String friendId);
  Future<List<UserProfile>> getPotentialFriends(String uid);
}
