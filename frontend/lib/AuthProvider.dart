import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  Map<String, dynamic>? _userData; // Holds email, firstName, lastName, userId

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get userData => _userData;

  // We change this to accept the whole Map from the backend
  void login(Map<String, dynamic> data) {
    _userData = data;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _userData = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
