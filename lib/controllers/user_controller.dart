import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:incident_tracker/models/app_alerts.dart';
import 'package:incident_tracker/models/user.dart';
import 'package:incident_tracker/services/auth_service.dart';
import 'package:incident_tracker/utils/show_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  bool isLoading = false;
  User? user;
  String? token;

  final AuthService _authService = AuthService();

  // isloading and user getters and setters
  bool get getIsLoading => isLoading;
  User? get getUser => user;
  String? get getToken => token;

  set setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  set setToken(String value) {
    token = value;
    notifyListeners();
  }

  set setUser(User value) {
    user = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      setIsLoading = true;
      var result = await _authService.login(email, password);
      setIsLoading = false;
      setUser = User.fromJSON(result['user']);
      setToken = result["token"];
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', result['token']);
      prefs.setString('user', json.encode(result['user']));
      return true;
    } catch (e) {
      setIsLoading = false;
      showToast(ErrorAlert(message: e.toString()));
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      prefs.remove('user');
      return true;
    } catch (e) {
      showToast(ErrorAlert(message: e.toString()));
      return false;
    }
  }
}
