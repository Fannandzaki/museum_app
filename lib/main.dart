import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Import login

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
        // Ubah Primary Swatch agar tidak bentrok, tapi kita akan pakai ColorConstant manual
        useMaterial3: true,
      ),
      home: LoginScreen(), // Ubah ke LoginScreen
    );
  }
}
