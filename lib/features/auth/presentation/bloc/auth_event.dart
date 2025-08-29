part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String profileImage;
  final int status;
  final String email;
  final String password;

  AuthSignUp({
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

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({required this.email, required this.password});
}

final class AuthIsUserLoggedIn extends AuthEvent {}

final class FetchAllUsers extends AuthEvent {}

class UsersUpdatedEvent extends AuthEvent {
  final List<User> users;
  UsersUpdatedEvent(this.users);
}

class UsersErrorEvent extends AuthEvent {
  final String message;
  UsersErrorEvent(this.message);
}
