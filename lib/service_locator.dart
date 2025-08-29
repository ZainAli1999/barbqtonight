import 'package:barbqtonight/core/cubits/app_user_cubit.dart';
import 'package:barbqtonight/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:barbqtonight/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:barbqtonight/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:barbqtonight/features/auth/domain/repository/auth_repository.dart';
import 'package:barbqtonight/features/auth/domain/usecases/current_user.dart';
import 'package:barbqtonight/features/auth/domain/usecases/fetch_users.dart';
import 'package:barbqtonight/features/auth/domain/usecases/user_login.dart';
import 'package:barbqtonight/features/auth/domain/usecases/user_sign_up.dart';
import 'package:barbqtonight/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  await _initCore();
  await _initAuth();
}

Future<void> _initCore() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  serviceLocator
    ..registerSingleton<SharedPreferences>(sharedPreferences)
    ..registerLazySingleton<AppUserCubit>(() => AppUserCubit());
}

Future<void> _initAuth() async {
  serviceLocator
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(serviceLocator()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator<FirebaseAuth>(),
        serviceLocator<FirebaseFirestore>(),
      ),
    );

  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator<AuthRemoteDataSource>(),
      serviceLocator<AuthLocalDataSource>(),
    ),
  );

  serviceLocator
    ..registerLazySingleton(() => UserSignUp(serviceLocator()))
    ..registerLazySingleton(() => UserLogin(serviceLocator()))
    ..registerLazySingleton(() => CurrentUser(serviceLocator()))
    ..registerLazySingleton(() => FetchUsers(serviceLocator()));

  serviceLocator.registerFactory<AuthBloc>(
    () => AuthBloc(
      userSignUp: serviceLocator<UserSignUp>(),
      userLogin: serviceLocator<UserLogin>(),
      currentUser: serviceLocator<CurrentUser>(),
      appUserCubit: serviceLocator<AppUserCubit>(),
      authLocalDataSource: serviceLocator<AuthLocalDataSource>(),
      fetchUsers: serviceLocator<FetchUsers>(),
    ),
  );
}
