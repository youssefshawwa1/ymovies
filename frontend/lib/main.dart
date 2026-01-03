import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';
import 'WatchlistProvider.dart';
import "LovedProvider.dart";
import 'AuthWrapper.dart';
import "global.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  // Check the disk (SharedPreferences) to see if a user is already saved
  await authProvider.checkLoadingStatus();

  runApp(
    // Change to MultiProvider to support multiple data stores
    MultiProvider(
      providers: [
        // Pass the already-initialized AuthProvider
        ChangeNotifierProvider.value(value: authProvider),

        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
        ChangeNotifierProvider(create: (_) => LovedProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.red,
      ),
      home: const AuthWrapper(),
    );
  }
}
