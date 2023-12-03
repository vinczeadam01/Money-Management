import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_management/features/profile/domain/profile_repository.dart';
import 'package:money_management/features/profile/domain/user_profile.dart';

const _userProfileCollection = 'users';

class FirebaseProfileRepository extends ProfileRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Future<UserProfile> create(String uid, String name, String email) async {
    final profile = UserProfile(
      uid: uid,
      name: name,
      email: email, 
      phone: ''
    );
    await _db
        .collection(_userProfileCollection)
        .withConverter(
            fromFirestore: _userProfileFromFirestore,
            toFirestore: _userProfileToFirestore)
        .doc(uid)
        .set(profile);
    return profile;
  }

  @override
  Future<UserProfile> getProfile(String uid) async {
    final snapshot = await _db
        .collection(_userProfileCollection)
        .withConverter(
            fromFirestore: _userProfileFromFirestore,
            toFirestore: _userProfileToFirestore)
        .doc(uid)
        .get();
    final profile = snapshot.data();
    if (profile == null) {
      throw Exception('Profile not found');
    }
    return profile;
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    await _db
        .collection(_userProfileCollection)
        .withConverter(
            fromFirestore: _userProfileFromFirestore,
            toFirestore: _userProfileToFirestore)
        .doc(profile.uid)
        .set(profile);
    return profile;
  }
  
  @override
  Future<List<UserProfile>> getAllUser() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(_userProfileCollection)
        .get();
    return snapshot.docs.map((doc) => UserProfile.fromJson(doc.data())).toList();
  }
}

UserProfile _userProfileFromFirestore(
  DocumentSnapshot<Map<String, dynamic>> snapshot,
  SnapshotOptions? options,
) =>
    UserProfile.fromJson(snapshot.data() ?? {});

Map<String, dynamic> _userProfileToFirestore(
        UserProfile profile, SetOptions? options) =>
    profile.toJson();
