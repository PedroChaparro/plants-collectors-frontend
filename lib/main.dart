import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plants_collectors/screens/login_screen.dart';
import 'package:plants_collectors/screens/plants_home.dart';
import 'package:plants_collectors/screens/signup_screen.dart';

Future<void> main() async {
  await dotenv.load(); // Load .enf file from the default file
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        "/home": (context) => const PlanstHome(),
      },
    );
  }
}
