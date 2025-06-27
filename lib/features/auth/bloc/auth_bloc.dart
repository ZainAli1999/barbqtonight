import 'package:barbqtonight/core/current_user_bloc/current_user_bloc.dart';
import 'package:barbqtonight/core/current_user_bloc/current_user_event.dart';
import 'package:barbqtonight/features/auth/bloc/auth_event.dart';
import 'package:barbqtonight/features/auth/bloc/auth_state.dart';
import 'package:barbqtonight/features/auth/model/auth_model.dart';
import 'package:barbqtonight/features/auth/repository/auth_local_repository.dart';
import 'package:barbqtonight/features/auth/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CurrentUserBloc _currentUserBloc;
  final AuthRepository _authRepository;
  final AuthLocalRepository _authLocalRepository;

  AuthBloc({
    required CurrentUserBloc currentUserBloc,
    required AuthRepository authRepository,
    required AuthLocalRepository authLocalRepository,
  }) : _currentUserBloc = currentUserBloc,
       _authRepository = authRepository,
       _authLocalRepository = authLocalRepository,
       super(AuthInitial()) {
    on<SignUpUserEvent>(_onSignUpUser);
    on<SignInUserEvent>(_onSignInUser);
    on<CheckEmailVerification>(_onCheckEmailVerification);
    on<ResendVerificationEmail>(_onResendVerificationEmail);

    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> _onSignUpUser(
    SignUpUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _authRepository.signUpUser(
      firstName: event.firstName,
      lastName: event.lastName,
      phoneNumber: event.phoneNumber,
      address: event.address,
      email: event.email,
      password: event.password,
    );

    switch (res) {
      case Left(value: final l):
        emit(AuthFailure(l.message));
        break;

      case Right(value: final r):
        _getDataSuccess(r, emit);
        break;
    }
  }

  Future<void> _onSignInUser(
    SignInUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _authRepository.signInUser(
      email: event.email,
      password: event.password,
    );

    switch (res) {
      case Left(value: final l):
        emit(AuthFailure(l.message));
        break;

      case Right(value: final r):
        _getDataSuccess(r, emit);
        break;
    }
  }

  Future<void> _onCheckEmailVerification(
    CheckEmailVerification event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _authRepository.checkEmailVerification();

    switch (res) {
      case Left(value: final l):
        emit(AuthFailure(l.message));
        break;

      case Right(value: final r):
        emit(AuthSuccess(r));
        break;
    }
  }

  Future<void> _onResendVerificationEmail(
    ResendVerificationEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _authRepository.sendVerificationEmail();

    switch (res) {
      case Left(value: final l):
        emit(AuthFailure(l.message));
        break;

      case Right(value: final r):
        emit(AuthSuccess(r));
        break;
    }
  }

  void _getDataSuccess(AuthModel user, Emitter<AuthState> emit) {
    _authLocalRepository.setUid(user.uid);

    _currentUserBloc.add(AddUserEvent(user));

    emit(AuthSuccess(user));
  }
}
