import 'dart:convert';
import 'package:barbqtonight/features/auth/data/models/user_model.dart';
import 'package:barbqtonight/features/auth/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalRepository {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void setUid(String? uid) {
    if (uid != null) {
      _sharedPreferences.setString('uid', uid);
    }
  }

  Future<void> saveUser(UserModel user) async {
    final jsonString = jsonEncode(user.toMap());
    await _sharedPreferences.setString('user', jsonString);
  }

  User? getUser() {
    final jsonString = _sharedPreferences.getString('user');
    if (jsonString == null) return null;
    final Map<String, dynamic> map = jsonDecode(jsonString);
    return UserModel.fromMap(map);
  }

  String? getToken() {
    return _sharedPreferences.getString('uid');
  }

  Future<void> removeToken() {
    return _sharedPreferences.remove('uid');
  }

  Future<void> removeUser() async {
    await _sharedPreferences.remove('user');
  }
}
