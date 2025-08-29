import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barbqtonight/core/utils/exceptions.dart';
import 'package:barbqtonight/features/auth/data/models/user_model.dart';
import 'package:barbqtonight/features/auth/domain/entities/user.dart' as user;

abstract interface class AuthRemoteDataSource {
  User? get currentUser;

  Future<user.User> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    required String profileImage,
    required int status,
    required String email,
    required String password,
  });

  Future<user.User> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<user.User?> getCurrentUserData();

  Stream<List<user.User>> fetchUsers();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<user.User> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    required String profileImage,
    required int status,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const ServerException('Firebase user is null during sign up');
      }

      final userModel = UserModel(
        createdAt: Timestamp.now(),
        uid: firebaseUser.uid,
        status: status,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        address: address,
        profileImage: profileImage,
        email: email,
      );

      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(userModel.toMap());

      log("User signed up: ${firebaseUser.uid}");
      return userModel;
    } on FirebaseAuthException catch (e, st) {
      log(
        "FirebaseAuth signUp error: ${e.code} - ${e.message}",
        stackTrace: st,
      );
      throw ServerException(e.message ?? 'Unknown Firebase Auth error');
    } catch (e, st) {
      log("Unknown signUp error: $e", stackTrace: st);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<user.User> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const ServerException('Firebase user is null during login');
      }

      final doc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!doc.exists || doc.data() == null) {
        throw const ServerException('User data not found in Firestore');
      }

      final userModel = UserModel.fromMap(
        doc.data()!,
      ).copyWith(email: firebaseUser.email ?? '');
      log("User logged in: ${firebaseUser.uid}");
      return userModel;
    } on FirebaseAuthException catch (e, st) {
      log("FirebaseAuth login error: ${e.code} - ${e.message}", stackTrace: st);
      throw ServerException(e.message ?? 'Unknown Firebase Auth error');
    } catch (e, st) {
      log("Unknown login error: $e", stackTrace: st);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<user.User?> getCurrentUserData() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      final doc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!doc.exists || doc.data() == null) return null;

      final userModel = UserModel.fromMap(
        doc.data()!,
      ).copyWith(email: firebaseUser.email ?? '');
      log("Current user fetched: ${firebaseUser.uid}");
      return userModel;
    } catch (e, st) {
      log("Error fetching current user: $e", stackTrace: st);
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<user.User>> fetchUsers() {
    try {
      return _firestore.collection('users').snapshots().map((snapshot) {
        final users =
            snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();

        log("📡 Users stream update (${users.length} users)");
        return users;
      });
    } catch (e, st) {
      log("Error in fetchUsers stream: $e", stackTrace: st);
      return Stream.error(ServerException(e.toString()));
    }
  }
}
