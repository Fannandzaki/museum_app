import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/color_constant.dart';
import '../widgets/input_widget.dart';
import '../widgets/tombol.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Daftar User Biasa (Hanya Bisa Lihat)
  final Map<String, String> dataUser = {
    "pengunjung": "pengunjung@museum.com",
  };

  // Daftar Admin (Bisa Edit/Hapus)
  final Map<String, String> dataAdmin = {
    "admin": "admin@museum.com",
  };

  void _handleLogin() {
    String inputName = nameController.text.trim().toLowerCase();
    String inputEmail = emailController.text.trim();

    if (inputName.isEmpty || inputEmail.isEmpty) {
      _showSnackBar("Nama dan Email tidak boleh kosong!", Colors.orange);
      return;
    }

    // 1. CEK ADMIN
    if (dataAdmin.containsKey(inputName) &&
        dataAdmin[inputName] == inputEmail) {
      // Login sebagai ADMIN (isAdmin = true)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(isAdmin: true)),
      );
      return;
    }

    // 2. CEK USER BIASA
    if (dataUser.containsKey(inputName) && dataUser[inputName] == inputEmail) {
      // Login sebagai USER (isAdmin = false)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(isAdmin: false)),
      );
      return;
    }

    // Jika tidak terdaftar
    _showSnackBar("Nama atau Email salah / tidak terdaftar!", Colors.redAccent);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.museum_outlined,
                    size: 80, color: ColorConstant.primary),
                const Gap(20),
                Text(
                  'Museum Login',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: ColorConstant.textTitle,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InputWidget(
                        lable: 'Nama Lengkap',
                        controller: nameController,
                      ),
                      const Gap(16),
                      InputWidget(
                        lable: 'Alamat Email',
                        controller: emailController,
                      ),
                      const Gap(30),
                      Tombol(
                        text: 'Masuk',
                        isFullwidth: true,
                        onPressed: _handleLogin,
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                const Text(
                  "Hint Admin: 'admin' & 'admin@museum.com'\nHint User: 'user' & 'user@museum.com'",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
