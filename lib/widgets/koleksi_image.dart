import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk cek kIsWeb
import 'package:flutter/material.dart';

class KoleksiImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const KoleksiImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Jika Path Kosong
    if (imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }

    // 2. Jika Gambar Asset (Bawaan Project)
    // Ciri-cirinya: path dimulai dengan 'assets/'
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (ctx, _, __) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.image_not_supported, color: Colors.grey),
              Text("Asset not found",
                  style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    // 3. Jika Gambar dari Internet
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (ctx, _, __) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }

    // 4. Jika Gambar Lokal (Dari Galeri HP / Laptop)
    if (kIsWeb) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      return Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (ctx, _, __) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      );
    }
  }
}
