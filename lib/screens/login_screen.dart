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

  // Hanya Daftar Admin yang boleh login di sini
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

    // Cek Apakah dia Admin
    if (dataAdmin.containsKey(inputName) &&
        dataAdmin[inputName] == inputEmail) {
      // Login Berhasil -> Masuk sebagai Admin
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeScreen(isAdmin: true)),
        (route) => false,
      );
    } else {
      _showSnackBar("Akun Pengelola tidak ditemukan!", Colors.redAccent);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () =>
              Navigator.pop(context), // Bisa kembali ke WelcomeScreen
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.admin_panel_settings,
                    size: 80, color: ColorConstant.primary),
                const Gap(20),
                Text(
                  'Login Pengelola',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: ColorConstant.textTitle,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text("Hanya untuk admin museum"),
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
                          lable: 'Username Admin', controller: nameController),
                      const Gap(16),
                      InputWidget(
                          lable: 'Email Admin', controller: emailController),
                      const Gap(30),
                      Tombol(
                          text: 'Masuk Dashboard',
                          isFullwidth: true,
                          onPressed: _handleLogin),
                    ],
                  ),
                ),
                const Gap(20),
                const Text(
                  "Hint: 'admin' & 'admin@museum.com'",
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
