import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';
import 'Login.dart';
import 'MainApp.dart';

//this auth wrapper, wraps the app, in order to use the login details, and know,
//if a user loged in or not, if not, then a login page will appear.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. We watch the AuthProvider for changes
    final auth = Provider.of<AuthProvider>(context);

    if (auth.isLoggedIn) {
      //if the user logged in, then let him use the app.
      return MainApp(userData: auth.userData!);
    } else {
      //if the user is not logged in then, show the login page instead,
      return LoginPage(
        //if login was successfull, call the auth.login to save the new login informataoin.
        onAuthComplete: (userData, isSignUp) {
          auth.login(userData);
        },
      );
    }
  }
}
