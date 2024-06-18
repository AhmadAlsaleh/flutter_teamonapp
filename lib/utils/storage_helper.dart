import 'package:flutter_teamonapp/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageHelper {
  static Future<void> saveAuthModel(AuthModel authModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authModel', jsonEncode(authModel.toJson()));
  }

  static Future<AuthModel?> loadAuthModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authModelString = prefs.getString('authModel');
    if (authModelString != null) {
      return AuthModel.fromJson(jsonDecode(authModelString));
    }
    return null;
  }

  static Future<void> removeAuthModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('authModel');
  }
}
