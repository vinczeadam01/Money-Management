import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:money_management/features/profile/domain/avatar_repository.dart';

class FirebaseStorageAvatarRepository extends AvatarRepository {
  final String userId;

  FirebaseStorageAvatarRepository([this.userId = '']);

  @override
  Future<String> getAvatar() async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child('avatars/$userId/avatar.png');

      String downloadUrl = await storageReference.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      // Hiba esetén alapértelmezett kép visszaadása
      return 'assets/anonymus_avatar.png';
    }
  }

  @override
  Future<void> saveAvatar(Uint8List bytes) async {
    try {
      // Firebase Storage referencia létrehozása
      Reference storageReference = FirebaseStorage.instance.ref().child('avatars/$userId/avatar.png');

      // Kép feltöltése a Storage-ba
      await storageReference.putData(bytes);
    } catch (e) {
      print('Hiba a képfeltöltés során: $e');
    }
  }
}
