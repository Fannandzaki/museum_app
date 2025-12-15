import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Hilangkan banner debug di pojok kanan
      title: 'Museum App',
      theme: ThemeData(
        primarySwatch: Colors.teal, // Tema warna utama aplikasi
        useMaterial3: true, // Pakai desain material terbaru (lebih modern)
      ),
      home: HomeScreen(), // Halaman pertama yang dibuka
    );
  }
}
