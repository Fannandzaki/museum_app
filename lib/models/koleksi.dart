// lib/models/koleksi.dart

class Koleksi {
  // Encapsulation: Properti dibuat final agar immutable (tidak bisa diubah sembarangan setelah dibuat)
  final String nama;
  final String imageUrl;
  final String deskripsi;
  final String kategori;

  // Constructor untuk inisialisasi Object
  Koleksi({
    required this.nama,
    required this.imageUrl,
    required this.deskripsi,
    required this.kategori,
  });
}

// Data Dummy (Representasi Object nyata)
final List<Koleksi> daftarKoleksi = [
  Koleksi(
    nama: 'Museum Geologi',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/f8/Museum_Geologi_Bandung.jpg',
    deskripsi: 'Museum yang menyimpan berbagai koleksi batuan dan fosil purba.',
    kategori: 'Sains',
  ),
  Koleksi(
    nama: 'Museum Fatahillah',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/73/Jakarta_History_Museum_2024.jpg',
    deskripsi: 'Museum sejarah yang terletak di kawasan Kota Tua Jakarta.',
    kategori: 'Sejarah',
  ),
  // Tambahkan data lainnya...
];