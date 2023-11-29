import 'package:money_management/features/core/domain/user.dart';

abstract class LoginRepository {
  Future<User> login({
    required String email,
    required String password,
  });
}
