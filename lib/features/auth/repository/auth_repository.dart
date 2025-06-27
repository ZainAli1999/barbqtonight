import 'package:barbqtonight/core/utils/failure.dart';
import 'package:barbqtonight/core/utils/firebase_constants.dart';
import 'package:barbqtonight/core/utils/type_defs.dart';
import 'package:barbqtonight/features/auth/model/auth_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureEither<AuthModel> signUpUser({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    required String email,
    required String password,
  }) async {
    String errorMessage = "";
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      await userCredential.user!.sendEmailVerification();

      AuthModel auth = AuthModel(
        createdAt: Timestamp.now(),
        uid: user.uid,
        status: 0,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        address: address,
        profileImage: "",
        email: email,
      );

      await _users.doc(user.uid).set(auth.toMap());

      return Right(auth);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is incorrect.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "email-already-in-use":
          errorMessage = "This email is already in use by another account.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Please try again later.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with email and password is disabled.";
          break;
        default:
          errorMessage = "An undefined error occurred.";
      }

      return Left(Failure(errorMessage));
    } catch (e) {
      return Left(Failure("An unexpected error occurred."));
    }
  }

  FutureEither<AuthModel> signInUser({
    required String email,
    required String password,
  }) async {
    String errorMessage = "";
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user == null) {
        return Left(Failure("User not found"));
      }

      if (!user.emailVerified) {
        await user.sendEmailVerification();

        final usersDoc = await _users.doc(user.uid).get();
        final authUser = AuthModel.fromMap(
          usersDoc.data() as Map<String, dynamic>,
        );

        return Right(authUser);
      }

      final emailExistUsersDoc =
          await _users.where("email", isEqualTo: email).get();

      if (emailExistUsersDoc.docs.isEmpty) {
        return Left(Failure("Email does not exist"));
      }

      final usersDoc = await _users.doc(user.uid).get();
      final authUser = AuthModel.fromMap(
        usersDoc.data() as Map<String, dynamic>,
      );

      if (authUser.status != 1) {
        return Left(
          Failure("Your account has been disabled by the administrator!"),
        );
      }

      return Right(authUser);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "user-not-found":
          errorMessage = "No user found with this email.";
          break;
        case "wrong-password":
          errorMessage = "Your password is incorrect.";
          break;
        case "invalid-credential":
          errorMessage = "Successfully signed out!";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "email-already-in-use":
          errorMessage = "This email is already in use by another account.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Please try again later.";
          break;
        case "operation-not-allowed":
          errorMessage = "Email and Password login is not enabled.";
          break;
        default:
          errorMessage = "An undefined error occurred. Code: ${e.code}";
      }
      return Left(Failure(errorMessage));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  FutureEither sendVerificationEmail() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return const Right(true);
      }
      return Left(Failure("User not found or email address already verified"));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  FutureEither checkEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && user.emailVerified) {
        await user.reload();
        final updatedUser = _auth.currentUser;
        return Right(updatedUser!);
      }
      return Left(Failure("User not found"));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
