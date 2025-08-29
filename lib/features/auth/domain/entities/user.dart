import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final Timestamp createdAt;
  final String uid;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String profileImage;
  final int status;
  final String email;

  User({
    required this.createdAt,
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.profileImage,
    required this.status,
    required this.email,
  });
}
