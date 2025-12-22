import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart'; // Ganti import ini

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Museum App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const WelcomeScreen(), // Mulai dari WelcomeScreen
    );
  }
}
