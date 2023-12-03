import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/expense/domain/expense.dart';
import 'package:money_management/features/profile/domain/user_profile.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ExpenseDetails extends ConsumerWidget {

  const ExpenseDetails({
    Key? key,
    required this.expense,
    required this.allUser,
  }) : super(key: key);
  
  final Expense expense;
  final List<UserProfile> allUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Name'),
            subtitle: Text(expense.name),
          ),
          ListTile(
            title: const Text('Description'),
            subtitle: Text(expense.description),
          ),
          ListTile(
            title: const Text('Amount'),
            subtitle: Text(expense.amount.toString()),
          ),
          if (expense.receiptUrl != null) ListTile(
            title: const Text('Receipt'),
            subtitle: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ZoomableImageScreen(imageUrl: expense.receiptUrl!),
                  ),
                );
              },
              child: Image.network(expense.receiptUrl!),
            ),
          ),
          if (expense.shareWith != null) 
            const Divider(),
            if (expense.shareWith != null) 
            const ListTile(
            title: Text('Share'),
            ),
          if (expense.shareWith != null) 
            for (final item in expense.shareWith!.entries)
              ListTile(
                title: Text(allUser.firstWhere((element) => element!.uid == item.key, orElse: () => UserProfile(uid: '', name: 'Unknown', email: '', phone: '', )).name),
                trailing: Text(item.value.toString()),
              ), 
        ],
      ),
    );
  }
}

class ZoomableImageScreen extends StatelessWidget {
  final String imageUrl;

  ZoomableImageScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Pop the current screen when tapped again
          Navigator.pop(context);
        },
        child: Container(
          child: PhotoViewGallery.builder(
            itemCount: 1,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            pageController: PageController(),
          ),
        ),
      ),
    );
  }
}
