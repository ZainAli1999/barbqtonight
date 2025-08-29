import 'dart:developer';

import 'package:barbqtonight/features/auth/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:barbqtonight/core/utils/exceptions.dart';
import 'package:barbqtonight/core/utils/failure.dart';
import 'package:barbqtonight/core/utils/type_defs.dart';
import 'package:barbqtonight/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:barbqtonight/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:barbqtonight/features/auth/domain/entities/user.dart';
import 'package:barbqtonight/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  FutureEither<User> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    required String profileImage,
    required int status,
    required String email,
    required String password,
  }) {
    return _getUser(() async {
      final user = await remoteDataSource.signUpWithEmailPassword(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        address: address,
        profileImage: profileImage,
        status: status,
        email: email,
        password: password,
      );
      await _cacheUser(user);
      log("✅ User signed up and cached: ${user.uid}");
      return user;
    }, action: "signUp");
  }

  @override
  FutureEither<User> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _getUser(() async {
      final user = await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );
      await _cacheUser(user);
      log("✅ User logged in and cached: ${user.uid}");
      return user;
    }, action: "login");
  }

  @override
  FutureEither<User> currentUser() async {
    try {
      final firebaseUser = remoteDataSource.currentUser;

      if (firebaseUser == null) {
        final cachedUser = localDataSource.getCachedUser();
        if (cachedUser != null) {
          log("ℹ️ Returning cached user: ${cachedUser.uid}");
          return Right(cachedUser);
        }
        return Left(Failure("User not logged in!"));
      }

      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return Left(Failure("User not found in Firestore!"));
      }

      await _cacheUser(user);
      log("ℹ️ Returning remote user: ${user.uid}");
      return Right(user);
    } on ServerException catch (e, st) {
      log("❌ Error fetching currentUser: ${e.message}", stackTrace: st);
      return Left(Failure(e.message));
    } catch (e, st) {
      log("❌ Unknown error in currentUser: $e", stackTrace: st);
      return Left(Failure(e.toString()));
    }
  }

  @override
  StreamEither<List<User>> fetchUsers() {
    try {
      return remoteDataSource.fetchUsers().map((users) {
        log("📡 Fetched ${users.length} users from Firestore");
        return Right(users);
      });
    } on ServerException catch (e, st) {
      log("❌ Error fetching users: ${e.message}", stackTrace: st);
      return Stream.value(Left(Failure(e.message)));
    } catch (e, st) {
      log("❌ Unknown error in fetchUsers: $e", stackTrace: st);
      return Stream.value(Left(Failure(e.toString())));
    }
  }

  /// ---- Helpers ----

  FutureEither<User> _getUser(
    Future<User> Function() fn, {
    required String action,
  }) async {
    try {
      final user = await fn();
      return Right(user);
    } on ServerException catch (e, st) {
      log("❌ $action failed: ${e.message}", stackTrace: st);
      return Left(Failure(e.message));
    } catch (e, st) {
      log("❌ Unknown error in $action: $e", stackTrace: st);
      return Left(Failure(e.toString()));
    }
  }

  Future<void> _cacheUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    await localDataSource.cacheUser(userModel);
    await localDataSource.cacheUid(user.uid);
  }
}
