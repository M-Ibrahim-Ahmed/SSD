import 'package:flutter/material.dart';
import 'auth/login_screen.dart';
import 'screens/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RB Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
      routes: {
        Dashboard.routeName: (context) => const Dashboard(),
      },
    );
  }
}
