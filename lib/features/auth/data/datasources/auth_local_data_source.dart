import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:barbqtonight/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  UserModel? getCachedUser();
  Future<void> removeCachedUser();

  Future<void> cacheUid(String uid);
  String? getCachedUid();
  Future<void> removeCachedUid();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  static const String _userKey = 'user';
  static const String _uidKey = 'uid';

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final jsonString = jsonEncode(user.toMap());
      await sharedPreferences.setString(_userKey, jsonString);
      log("Cached user: ${user.uid}");
    } catch (e, st) {
      log("Failed to cache user: $e", stackTrace: st);
    }
  }

  @override
  UserModel? getCachedUser() {
    try {
      final jsonString = sharedPreferences.getString(_userKey);
      if (jsonString == null) return null;

      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return UserModel.fromMap(jsonMap);
    } catch (e, st) {
      log("Failed to decode cached user: $e", stackTrace: st);
      return null;
    }
  }

  @override
  Future<void> removeCachedUser() async {
    try {
      await sharedPreferences.remove(_userKey);
      log("Removed cached user");
    } catch (e, st) {
      log("Failed to remove cached user: $e", stackTrace: st);
    }
  }

  @override
  Future<void> cacheUid(String uid) async {
    try {
      await sharedPreferences.setString(_uidKey, uid);
      log("Cached UID: $uid");
    } catch (e, st) {
      log("Failed to cache UID: $e", stackTrace: st);
    }
  }

  @override
  String? getCachedUid() {
    try {
      return sharedPreferences.getString(_uidKey);
    } catch (e, st) {
      log("Failed to read cached UID: $e", stackTrace: st);
      return null;
    }
  }

  @override
  Future<void> removeCachedUid() async {
    try {
      await sharedPreferences.remove(_uidKey);
      log("Removed cached UID");
    } catch (e, st) {
      log("Failed to remove cached UID: $e", stackTrace: st);
    }
  }
}
