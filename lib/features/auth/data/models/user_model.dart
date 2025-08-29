import 'package:barbqtonight/features/auth/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends User {
  UserModel({
    required super.createdAt,
    required super.uid,
    required super.firstName,
    required super.lastName,
    required super.phoneNumber,
    required super.address,
    required super.profileImage,
    required super.status,
    required super.email,
  });
  UserModel copyWith({
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
    return UserModel(
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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
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

  factory UserModel.fromEntity(User user) {
    return UserModel(
      uid: user.uid,
      firstName: user.firstName,
      lastName: user.lastName,
      phoneNumber: user.phoneNumber,
      address: user.address,
      profileImage: user.profileImage,
      email: user.email,
      status: user.status,
      createdAt: user.createdAt,
    );
  }
}
