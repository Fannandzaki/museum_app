import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/color_constant.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon / Logo
                Icon(Icons.museum_rounded,
                    size: 80, color: ColorConstant.primary),
                const Gap(20),
                Text(
                  'Selamat Datang',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.textTitle,
                  ),
                ),
                Text(
                  'Museum Digital App',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const Gap(40),

                // Pilihan 1: PENGUNJUNG (Tanpa Login)
                _buildRoleCard(
                  context,
                  title: 'Pengunjung',
                  subtitle: 'Masuk tanpa login, hanya melihat koleksi.',
                  icon: Icons.person_outline_rounded,
                  color: Colors.blueAccent,
                  onTap: () {
                    // Langsung masuk Home sebagai User Biasa (isAdmin: false)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomeScreen(isAdmin: false)),
                    );
                  },
                ),
                const Gap(20),

                // Pilihan 2: PENGELOLA (Login Dulu)
                _buildRoleCard(
                  context,
                  title: 'Pengelola',
                  subtitle: 'Login untuk mengelola data museum.',
                  icon: Icons.admin_panel_settings_outlined,
                  color: Colors.orange,
                  onTap: () {
                    // Arahkan ke Login Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context,
      {required String title,
      required String subtitle,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const Gap(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.textTitle,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
