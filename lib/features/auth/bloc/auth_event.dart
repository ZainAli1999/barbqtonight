abstract class AuthEvent {}

class SignUpUserEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String email;
  final String password;

  SignUpUserEvent({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.password,
  });
}

class SignInUserEvent extends AuthEvent {
  final String email;
  final String password;
  SignInUserEvent({required this.email, required this.password});
}

class CheckEmailVerification extends AuthEvent {}

class ResendVerificationEmail extends AuthEvent {}
