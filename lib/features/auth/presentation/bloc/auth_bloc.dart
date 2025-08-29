import 'dart:async';
import 'package:barbqtonight/core/cubits/app_user_cubit.dart';
import 'package:barbqtonight/core/utils/use_case.dart';
import 'package:barbqtonight/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:barbqtonight/features/auth/data/models/user_model.dart';
import 'package:barbqtonight/features/auth/domain/entities/user.dart';
import 'package:barbqtonight/features/auth/domain/usecases/current_user.dart';
import 'package:barbqtonight/features/auth/domain/usecases/fetch_users.dart';
import 'package:barbqtonight/features/auth/domain/usecases/user_login.dart';
import 'package:barbqtonight/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final AuthLocalDataSource _authLocalDataSource;
  final FetchUsers _fetchUsers;

  StreamSubscription? _usersSubscription;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required AuthLocalDataSource authLocalDataSource,
    required FetchUsers fetchUsers,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       _authLocalDataSource = authLocalDataSource,
       _fetchUsers = fetchUsers,
       super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<FetchAllUsers>(_onFetchAllUsers);
    on<UsersUpdatedEvent>(_onUsersUpdated);
    on<UsersErrorEvent>(_onUsersError);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _currentUser(NoParams());

    switch (res) {
      case Left(value: final l):
        emit(AuthFailure(l.message));
        break;

      case Right(value: final r):
        await _emitAuthSuccess(r, emit);
        break;
    }
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
        address: event.address,
        profileImage: event.profileImage,
        status: event.status,
        email: event.email,
        password: event.password,
      ),
    );

    switch (res) {
      case Left(value: final l):
        emit(AuthFailure(l.message));
        break;

      case Right(value: final r):
        await _emitAuthSuccess(r, emit);
        break;
    }
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );

    switch (res) {
      case Left(value: final l):
        emit(AuthFailure(l.message));
        break;

      case Right(value: final r):
        await _emitAuthSuccess(r, emit);
        break;
    }
  }

  Future<void> _emitAuthSuccess(User user, Emitter<AuthState> emit) async {
    final userModel = UserModel(
      createdAt: user.createdAt,
      uid: user.uid,
      status: user.status,
      firstName: user.firstName,
      lastName: user.lastName,
      phoneNumber: user.phoneNumber,
      address: user.address,
      profileImage: user.profileImage,
      email: user.email,
    );
    await _authLocalDataSource.cacheUser(userModel);
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
    add(FetchAllUsers());
  }

  void _onFetchAllUsers(FetchAllUsers event, Emitter<AuthState> emit) async {
    await _usersSubscription?.cancel();

    _usersSubscription = _fetchUsers(NoParams()).listen((res) {
      switch (res) {
        case Left(value: final l):
          add(UsersErrorEvent(l.message));
          break;
        case Right(value: final r):
          add(UsersUpdatedEvent(r));
          break;
      }
    });
  }

  void _onUsersUpdated(UsersUpdatedEvent event, Emitter<AuthState> emit) {
    emit(UsersDisplaySuccess(event.users));
  }

  void _onUsersError(UsersErrorEvent event, Emitter<AuthState> emit) {
    emit(AuthFailure(event.message));
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }
}
