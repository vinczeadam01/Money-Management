import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/login/domain/login_repository.dart';
import 'package:money_management/features/login/infrastructure/dummy_login_repository.dart';

final loginRepositoryProvider = Provider<LoginRepository>(
  (ref) => DummyLoginRepository(),
);
