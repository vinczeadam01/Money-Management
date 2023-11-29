import 'package:money_management/features/core/domain/user.dart';
import 'package:money_management/features/sign_up/domain/sign_up_form.dart';
import 'package:money_management/features/sign_up/domain/sign_up_repository.dart';

class DummySignUpRepository extends SignUpRepository {
  @override
  Future<User> signUp({required SignUpForm signUpForm}) async {
    return User(
      uid: '1',
      name: signUpForm.name,
      email: signUpForm.email,
    );
  }
}
