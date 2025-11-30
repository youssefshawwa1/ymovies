import 'package:flutter/material.dart';
import './MainApp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YMOVIES',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black, // Whole app background
        primarySwatch: Colors.red,
      ),
      home: MainApp(), // Changed to MainApp
    );
  }
}
