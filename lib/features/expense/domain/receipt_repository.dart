import 'dart:typed_data';


abstract class ReceiptRepository {
  Future<String?> getReceipt();
  Future<void> saveReceipt(Uint8List bytes);
}
