import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';
import 'Login.dart';
import 'MainApp.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. We watch the AuthProvider for changes
    final auth = Provider.of<AuthProvider>(context);

    if (auth.isLoggedIn) {
      // 1. Pass the whole map to MainApp so it can use ID, names, etc.
      return MainApp(userData: auth.userData!);
    } else {
      return LoginPage(
        onAuthComplete: (userData, isSignUp) {
          auth.login(userData);
        },
      );
    }
  }
}
