import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/friends/domain/friend_repository.dart';
import 'package:money_management/features/friends/infrastructure/firebase_friend_repository.dart';

final friendRepositoryProvider = Provider<FriendRepository>((ref) {
  return FirebaseFriendRepository();
});