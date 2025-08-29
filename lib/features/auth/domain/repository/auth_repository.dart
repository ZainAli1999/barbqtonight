import 'package:barbqtonight/core/utils/type_defs.dart';
import 'package:barbqtonight/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  FutureEither<User> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    required String profileImage,
    required int status,
    required String email,
    required String password,
  });
  FutureEither<User> loginWithEmailPassword({
    required String email,
    required String password,
  });
  FutureEither<User> currentUser();

  StreamEither<List<User>> fetchUsers();
}
