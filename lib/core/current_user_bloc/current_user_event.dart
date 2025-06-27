import 'package:barbqtonight/features/auth/model/auth_model.dart';

abstract class CurrentUserEvent {}

class AddUserEvent extends CurrentUserEvent {
  final AuthModel user;

  AddUserEvent(this.user);
}

class RemoveUserEvent extends CurrentUserEvent {}
