import 'package:cloud_firestore/cloud_firestore.dart';

class AuthModel {
  final Timestamp createdAt;
  final String uid;
  final int status;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String profileImage;
  final String email;
  AuthModel({
    required this.createdAt,
    required this.uid,
    required this.status,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.profileImage,
    required this.email,
  });

  AuthModel copyWith({
    Timestamp? createdAt,
    String? uid,
    int? status,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
    String? profileImage,
    String? email,
  }) {
    return AuthModel(
      createdAt: createdAt ?? this.createdAt,
      uid: uid ?? this.uid,
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      profileImage: profileImage ?? this.profileImage,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'createdAt': createdAt.toDate().toIso8601String(),
      'uid': uid,
      'status': status,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'address': address,
      'profileImage': profileImage,
      'email': email,
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      createdAt:
          map['createdAt'] is Timestamp
              ? map['createdAt']
              : Timestamp.fromDate(DateTime.parse(map['createdAt'])),
      uid: map['uid'] as String,
      status: map['status'] as int,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      address: map['address'] as String,
      profileImage: map['profileImage'] as String,
      email: map['email'] as String,
    );
  }
}
