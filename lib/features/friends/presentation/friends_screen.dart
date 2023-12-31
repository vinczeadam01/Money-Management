import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/auth/application/auth_controller.dart';
import 'package:money_management/features/auth/domain/auth_state.dart';
import 'package:money_management/features/core/domain/user.dart';
import 'package:money_management/features/core/presentation/app_drawer.dart';
import 'package:money_management/features/friends/application/friend_controller.dart';
import 'package:money_management/features/friends/infrastructure/providers.dart';
import 'package:money_management/features/profile/domain/user_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final friendRepository = ref.watch(friendRepositoryProvider);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.friends),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: switch (authState) {
        Unknown() || Unauthenticated() => const Center(
            child: CircularProgressIndicator(),
          ),
        Authenticated(:final user) => FloatingActionButton(
          onPressed: () async {
            final potentialFriends = await friendRepository.getPotentialFriends(user.uid);
            showAddFriendDialog(context, ref, potentialFriends);
          },
          child: const Icon(Icons.add),
        )
      },
      body: switch (authState) {
        Unknown() || Unauthenticated() => const Center(
            child: CircularProgressIndicator(),
          ),
        Authenticated(:final user) => _FriendsScreen(user: user),
      },
    );
  }

  void showAddFriendDialog(BuildContext context, WidgetRef ref, List<UserProfile> potentialFriends) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String friendUid = potentialFriends.isNotEmpty ? potentialFriends[0].uid : '';
        return AlertDialog(
          title: Text(localizations.addFriend),
          content: DropdownButtonFormField(
            value: friendUid,
            onChanged: (String? newValue) {
              friendUid = newValue!;
            },
            items: potentialFriends.map<DropdownMenuItem<String>>((UserProfile value) {
              return DropdownMenuItem<String>(
                value: value.uid,
                child: Text(value.name),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: localizations.friend,
            ),
            menuMaxHeight: 300,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.add),
              onPressed: () {
                final friendController = ref.read(friendControllerProvider.notifier);
                friendController.addFriend(friendUid);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.friendAdded)),
                );
                Navigator.of(context).pop(); 
                return ref.refresh(friendControllerProvider);
              },
            ),
            TextButton(
              child: Text(localizations.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _FriendsScreen extends ConsumerWidget {
  const _FriendsScreen({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsyncValue = ref.watch(friendControllerProvider);
    final localizations = AppLocalizations.of(context)!;
    return switch (friendsAsyncValue) {
      AsyncError() => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(localizations.cantLoadFriends),
            ],
          ),
        ),
      AsyncData(:final value) => _FriendList(
          user: user,
          friends: value,
        ),
      _ => const Center(
          child: CircularProgressIndicator(),
        ),
    };
  }
}

class _FriendList extends ConsumerStatefulWidget {
  const _FriendList({
    required this.user,
    required this.friends,
  });

  final User user;
  final List<UserProfile> friends;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FriendListState();
}

class _FriendListState extends ConsumerState<_FriendList> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget.friends.length,
                itemBuilder: (context, index) {
                  final friend = widget.friends[index];
                  return ListTile(
                    title: Text(friend.name),
                    subtitle: Text(friend.email),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: friend,
                          child: Text(localizations.delete),
                        ),
                      ],
                      onSelected: (friend) async {
                        final friendController = ref.read(friendControllerProvider.notifier);
                        friendController.removeFriend(friend.uid);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localizations.friendRemoved)),
                        );
                        return ref.refresh(friendControllerProvider);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }


}


