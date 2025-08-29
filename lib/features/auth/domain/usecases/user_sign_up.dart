import 'package:barbqtonight/core/utils/type_defs.dart';
import 'package:barbqtonight/core/utils/use_case.dart';
import 'package:barbqtonight/features/auth/domain/repository/auth_repository.dart';
import 'package:barbqtonight/features/auth/domain/entities/user.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);

  @override
  FutureEither<User> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      firstName: params.firstName,
      lastName: params.lastName,
      phoneNumber: params.phoneNumber,
      address: params.address,
      profileImage: params.profileImage,
      status: params.status,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String profileImage;
  final int status;
  final String email;
  final String password;
  UserSignUpParams({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.profileImage,
    required this.status,
    required this.email,
    required this.password,
  });
}
