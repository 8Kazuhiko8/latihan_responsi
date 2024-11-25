import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latihan_responsi/screens/home_screen.dart';
import 'package:latihan_responsi/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');

  // Initialize SharedPreferences
  await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space News App',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final prefs = snapshot.data as SharedPreferences;
            final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
            return isLoggedIn ? HomeScreen() : LoginScreen();
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}