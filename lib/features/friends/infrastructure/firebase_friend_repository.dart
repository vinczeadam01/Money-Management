import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_management/features/friends/domain/friend_repository.dart';
import 'package:money_management/features/profile/domain/user_profile.dart';

const _userProfileCollection = 'users';

class FirebaseFriendRepository implements FriendRepository {
  final _db = FirebaseFirestore.instance;
  
  @override
  Future<void> addFriend(String currentUserId, String friendId) async {
    await _db
        .collection(_userProfileCollection)
        .doc(currentUserId)
        .collection('friends').doc(friendId).set({
          'friend': true,
        });
    await _db
        .collection(_userProfileCollection)
        .doc(friendId)
        .collection('friends').doc(currentUserId).set({
          'friend': true,
        });
  }

  @override
  Future<List<UserProfile>> getFriends(String uid) async {
      final friendIdsSnapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('friends')
        .get();

      final friendIds = friendIdsSnapshot
        .docs
        .map((doc) => doc.id)
        .toList();

      final friendsSnapshot = await _db.collection('users').where(FieldPath.documentId, whereIn: friendIds).get();
      
      final friends = friendsSnapshot.docs.map((doc) => UserProfile.fromJson(doc.data())).toList();


      return friends;
  }

  @override
  Future<List<UserProfile>> getPotentialFriends(String uid) async {
    final friendIdsSnapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('friends')
        .get();

    final friendIds = friendIdsSnapshot
        .docs
        .map((doc) => doc.id)
        .toList();

    friendIds.add(uid); // add current user id to the list

    final potentialFriendsSnapshot = await _db.collection('users').where(FieldPath.documentId, whereNotIn: friendIds).get();

    final potentialFriends = potentialFriendsSnapshot.docs.map((doc) => UserProfile.fromJson(doc.data())).toList();

    return potentialFriends;
  }

  @override
  Future<void> removeFriend(String currentUserId, String friendId) {
    return Future.wait([
      _db
        .collection(_userProfileCollection)
        .doc(currentUserId)
        .collection('friends').doc(friendId).delete(),
      _db
        .collection(_userProfileCollection)
        .doc(friendId)
        .collection('friends').doc(currentUserId).delete(),
    ]);
  }
}
