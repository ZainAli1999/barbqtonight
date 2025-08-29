import 'package:barbqtonight/core/utils/type_defs.dart';
import 'package:barbqtonight/core/utils/use_case.dart';
import 'package:barbqtonight/features/auth/domain/entities/user.dart';
import 'package:barbqtonight/features/auth/domain/repository/auth_repository.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;
  const UserLogin(this.authRepository);

  @override
  FutureEither<User> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}
