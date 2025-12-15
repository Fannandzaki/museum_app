import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/color_constant.dart'; // Sesuaikan path import

class Tombol extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullwidth;

  const Tombol({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFullwidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullwidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
