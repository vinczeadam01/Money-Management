import 'dart:typed_data';


abstract class AvatarRepository {
  Future<String> getAvatar();
  Future<void> saveAvatar(Uint8List bytes);
}
