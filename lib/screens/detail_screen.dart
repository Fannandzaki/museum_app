import 'package:flutter/material.dart';
import '../models/koleksi_model.dart';

class DetailScreen extends StatelessWidget {
  final Koleksi koleksi;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  DetailScreen({required this.koleksi, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan close button
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detail Koleksi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Image
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[200],
              child: Image.network(
                koleksi.urlGambar,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stackTrace) => Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title dan kondisi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              koleksi.nama,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              koleksi.kategori,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getConditionColor(koleksi.kondisi),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          koleksi.kondisi,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Info Grid
                  Row(
                    children: [
                      Expanded(
                        child: _infoCard(
                          Icons.calendar_month,
                          'Tahun',
                          '${koleksi.tahun}-an',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _infoCard(
                          Icons.location_on,
                          'Lokasi',
                          koleksi.lokasi,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _infoCard(Icons.code, 'ID Koleksi', koleksi.id),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Deskripsi
                  Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    koleksi.deskripsi,
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                  SizedBox(height: 20),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onEdit,
                          icon: Icon(Icons.edit),
                          label: Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onDelete,
                          icon: Icon(Icons.delete, color: Colors.red),
                          label: Text(
                            'Hapus',
                            style: TextStyle(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Color _getConditionColor(String kondisi) {
    switch (kondisi) {
      case 'Baik':
        return Colors.green;
      case 'Cukup':
        return Colors.orange;
      case 'Rusak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
