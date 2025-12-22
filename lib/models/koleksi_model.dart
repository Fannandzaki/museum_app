// lib/models/koleksi_model.dart

// Class Induk
class Koleksi {
  String id;
  String nama;
  String deskripsi;
  int tahun;
  String kategori; // Kategori koleksi
  String kondisi; // Baik, Cukup, Rusak
  String lokasi; // Lokasi penyimpanan
  String urlGambar; // URL gambar koleksi
  String creatorName; // Nama pencipta (Pelukis/Pematung/Fotografer)

  Koleksi({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.tahun,
    required this.kategori,
    required this.kondisi,
    required this.lokasi,
    required this.urlGambar,
    required this.creatorName,
  });
}

// Class Turunan: Lukisan
class Lukisan extends Koleksi {
  String pelukis;

  Lukisan({
    required String id,
    required String nama,
    required String deskripsi,
    required int tahun,
    required String kondisi,
    required String lokasi,
    required String urlGambar,
    required this.pelukis,
  }) : super(
          id: id,
          nama: nama,
          deskripsi: deskripsi,
          tahun: tahun,
          kategori: 'Lukisan',
          kondisi: kondisi,
          lokasi: lokasi,
          urlGambar: urlGambar,
          creatorName: pelukis,
        );
}

// Class Turunan: Patung
class Patung extends Koleksi {
  String pematung;

  Patung({
    required String id,
    required String nama,
    required String deskripsi,
    required int tahun,
    required String kondisi,
    required String lokasi,
    required String urlGambar,
    required this.pematung,
  }) : super(
          id: id,
          nama: nama,
          deskripsi: deskripsi,
          tahun: tahun,
          kategori: 'Patung',
          kondisi: kondisi,
          lokasi: lokasi,
          urlGambar: urlGambar,
          creatorName: pematung,
        );
}

// Class Turunan: Fotografi
class Fotografi extends Koleksi {
  String fotografer;

  Fotografi({
    required String id,
    required String nama,
    required String deskripsi,
    required int tahun,
    required String kondisi,
    required String lokasi,
    required String urlGambar,
    required this.fotografer,
  }) : super(
          id: id,
          nama: nama,
          deskripsi: deskripsi,
          tahun: tahun,
          kategori: 'Fotografi',
          kondisi: kondisi,
          lokasi: lokasi,
          urlGambar: urlGambar,
          creatorName: fotografer,
        );
}

// Simpan data sementara di Memory (pengganti List global di console)
List<Koleksi> daftarKoleksi = [
  Lukisan(
    id: 'L01',
    nama: 'Keris Majapahit',
    deskripsi:
        'Keris peninggalan era Majapahit dengan ukiran naga yang sangat detail. Merupakan pusaka turun temurun yang memiliki nilai sejarah tinggi.',
    tahun: 1400,
    pelukis: 'Senjata Tradisional',
    kondisi: 'Baik',
    lokasi: 'Ruang A - Rak 12',
    urlGambar:
        '../../assets/images/keris-majapahit.jpg',
  ),
  Patung(
    id: 'P01',
    nama: 'Arca Ganesha',
    deskripsi:
        'Arca Ganesha dari abad ke-9 yang ditemukan di area Candi Prambanan. Terbuat dari batu andesit dengan detail ukiran yang menakjubkan.',
    tahun: 800,
    pematung: 'Patung',
    kondisi: 'Cukup',
    lokasi: 'Ruang C - Display Utama',
    urlGambar:
        '../../assets/images/arca-ganesha.jpg',
  ),
  Fotografi(
    id: 'F01',
    nama: 'Guci Dinasti Ming',
    deskripsi:
        'Guci berukuran besar dari Dinasti Ming dengan motif burung teratai yang indah. Kondisi masih sangat baik dengan glaze yang mulus.',
    tahun: 1500,
    fotografer: 'Keramik',
    kondisi: 'Baik',
    lokasi: 'Ruang B - Rak 5',
    urlGambar:
        '../../assets/images/guci-dinasti-ming.jpg',
  ),
  Lukisan(
    id: 'L02',
    nama: 'Kain Batik Keraton',
    deskripsi:
        'Kain batik motif parang rusak yang merupakan koleksi pribadi keraton Yogyakarta. Dibuat dengan teknik batik tulis tradisional.',
    tahun: 1700,
    pelukis: 'Senjata Tradisional',
    kondisi: 'Cukup',
    lokasi: 'Ruang D - Rak 8',
    urlGambar:
        '../../assets/images/kain-batik.jpg',
  ),
  Patung(
    id: 'P02',
    nama: 'Prasasti Kuno',
    deskripsi:
        'Prasasti berukuran besar dengan aksara Pallawa yang berisi catatan peninggal tentang kerajaan masa lampau. Ditemukan di Candi Sojiwan.',
    tahun: 600,
    pematung: 'Patung',
    kondisi: 'Baik',
    lokasi: 'Ruang A - Display 1',
    urlGambar:
        '../../assets/images/prasasti-kuno.jpg',
  ),
];
