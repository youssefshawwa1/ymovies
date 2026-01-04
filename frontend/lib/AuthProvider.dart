import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

//this provider, saves the login credeniaals, and notify listners if its changed.
class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  Map<String, dynamic>? _userData;
  //is login a variable to know if the user loged in or not.
  //userData, is a variable that holds the user data.
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

  //clear the login details from the app, and from the local storage.
  void logout() async {
    _isLoggedIn = false;
    _userData = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  //here loads the login detaails from the local storage,
  //and if its not there, then it should login.
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
