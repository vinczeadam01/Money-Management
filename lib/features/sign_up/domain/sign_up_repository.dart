import 'package:money_management/features/core/domain/user.dart';
import 'package:money_management/features/sign_up/domain/sign_up_form.dart';

abstract class SignUpRepository {
  Future<User> signUp({required SignUpForm signUpForm});
}
