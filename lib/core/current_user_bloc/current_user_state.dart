import 'package:barbqtonight/features/auth/model/auth_model.dart';

abstract class CurrentUserState {}

class UserInitialState extends CurrentUserState {}

class UserAddedState extends CurrentUserState {
  final AuthModel user;

  UserAddedState(this.user);
}
