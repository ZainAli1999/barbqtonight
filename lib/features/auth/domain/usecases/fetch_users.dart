import 'package:barbqtonight/core/utils/type_defs.dart';
import 'package:barbqtonight/core/utils/use_case.dart';
import 'package:barbqtonight/features/auth/domain/entities/user.dart';
import 'package:barbqtonight/features/auth/domain/repository/auth_repository.dart';

class FetchUsers implements StreamUseCase<List<User>, NoParams> {
  final AuthRepository authRepository;
  const FetchUsers(this.authRepository);

  @override
  StreamEither<List<User>> call(NoParams params) {
    return authRepository.fetchUsers();
  }
}
