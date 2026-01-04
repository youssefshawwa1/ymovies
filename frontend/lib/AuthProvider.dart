import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  Map<String, dynamic>? _userData;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get userData => _userData;

  void login(Map<String, String> data) async {
    _userData = data;
    _isLoggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', data['email'] ?? '');
    await prefs.setString('userId', data['userId'].toString());
    await prefs.setString('firstName', data['firstName'] ?? '');
    await prefs.setString('lastName', data['lastName'] ?? '');
    notifyListeners();
  }

  void updateLocalUserData(Map<String, String> newData) {
    if (_userData != null) {
      _userData!.addAll(newData);
      notifyListeners();
    }
  }

  void logout() async {
    _isLoggedIn = false;
    _userData = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  Future<void> checkLoadingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');

    if (email != null) {
      _userData = {
        'email': email,
        'userId': prefs.getString('userId'),
        'firstName': prefs.getString('firstName'),
        'lastName': prefs.getString('lastName'),
      };
      _isLoggedIn = true;
      notifyListeners();
    }
  }
}
