import 'package:barbqtonight/core/utils/type_defs.dart';
import 'package:barbqtonight/core/utils/use_case.dart';
import 'package:barbqtonight/features/auth/domain/entities/user.dart';
import 'package:barbqtonight/features/auth/domain/repository/auth_repository.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  FutureEither<User> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
