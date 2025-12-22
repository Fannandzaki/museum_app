import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/koleksi_model.dart';
import '../constants/color_constant.dart';
import '../widgets/koleksi_image.dart';

class DetailScreen extends StatelessWidget {
  final Koleksi koleksi;
  // Callback ini akan NULL jika user biasa
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  DetailScreen({required this.koleksi, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    // Cek apakah mode admin (ada tombol edit/delete)
    bool isAdminMode = onEdit != null && onDelete != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Full Width di atas
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: KoleksiImage(
                    imagePath: koleksi.urlGambar, // Pakai widget baru
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                // Tombol Close Melayang
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul & Kategori
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              koleksi.nama,
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: ColorConstant.textTitle,
                              ),
                            ),
                            Text(
                              koleksi.kategori,
                              style: GoogleFonts.inter(
                                color: ColorConstant.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),

                  // Info Cards (Tahun, Lokasi, Kreator)
                  Row(
                    children: [
                      _infoItem(
                          Icons.calendar_today, "Tahun", "${koleksi.tahun}"),
                      _infoItem(
                          Icons.person_outline, "Kreator", koleksi.creatorName),
                      _infoItem(
                          Icons.location_on_outlined, "Lokasi", koleksi.lokasi),
                    ],
                  ),
                  const Gap(24),

                  // Deskripsi
                  Text(
                    "Tentang Koleksi",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Gap(8),
                  Text(
                    koleksi.deskripsi,
                    style:
                        GoogleFonts.inter(color: Colors.grey[700], height: 1.6),
                  ),
                  const Gap(30),

                  // LOGIKA: Tombol hanya muncul jika isAdminMode = true
                  if (isAdminMode) ...[
                    Divider(),
                    const Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onEdit,
                            icon: Icon(Icons.edit, size: 18),
                            label: Text('Edit'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              side: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onDelete,
                            icon: Icon(Icons.delete,
                                size: 18, color: Colors.white),
                            label: Text('Hapus',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Tampilan User Biasa (Hanya pesan kecil atau kosong)
                    Center(
                      child: Text(
                        "~ Museum Digital 2025 ~",
                        style: GoogleFonts.inter(
                            color: Colors.grey[300], fontSize: 12),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const Gap(4),
          Text(label,
              style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
