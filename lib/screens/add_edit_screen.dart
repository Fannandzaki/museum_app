import 'package:flutter/material.dart';
import '../models/koleksi_model.dart';

class AddEditScreen extends StatefulWidget {
  final Koleksi? koleksi;
  final Function(Koleksi)? onSave;

  AddEditScreen({this.koleksi, this.onSave});

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final _idController = TextEditingController();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _tahunController = TextEditingController();
  final _extraController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _urlGambarController = TextEditingController();

  String _selectedType = 'Lukisan';
  String _selectedKondisi = 'Baik';
  final List<String> _types = ['Lukisan', 'Patung', 'Fotografi'];
  final List<String> _kondisiList = ['Baik', 'Cukup', 'Rusak'];

  @override
  void initState() {
    super.initState();
    if (widget.koleksi != null) {
      var item = widget.koleksi!;
      _idController.text = item.id;
      _namaController.text = item.nama;
      _deskripsiController.text = item.deskripsi;
      _tahunController.text = item.tahun.toString();
      _lokasiController.text = item.lokasi;
      _urlGambarController.text = item.urlGambar;
      _selectedKondisi = item.kondisi;

      if (item is Lukisan) {
        _selectedType = 'Lukisan';
        _extraController.text = item.pelukis;
      } else if (item is Patung) {
        _selectedType = 'Patung';
        _extraController.text = item.pematung;
      } else if (item is Fotografi) {
        _selectedType = 'Fotografi';
        _extraController.text = item.fotografer;
      }
    }
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      String id = _idController.text;
      String nama = _namaController.text;
      String deskripsi = _deskripsiController.text;
      int tahun = int.parse(_tahunController.text);
      String extra = _extraController.text;
      String lokasi = _lokasiController.text;
      String urlGambar = _urlGambarController.text;

      Koleksi newItem;

      if (_selectedType == 'Lukisan') {
        newItem = Lukisan(
          id: id,
          nama: nama,
          deskripsi: deskripsi,
          tahun: tahun,
          pelukis: extra,
          kondisi: _selectedKondisi,
          lokasi: lokasi,
          urlGambar: urlGambar,
        );
      } else if (_selectedType == 'Patung') {
        newItem = Patung(
          id: id,
          nama: nama,
          deskripsi: deskripsi,
          tahun: tahun,
          pematung: extra,
          kondisi: _selectedKondisi,
          lokasi: lokasi,
          urlGambar: urlGambar,
        );
      } else {
        newItem = Fotografi(
          id: id,
          nama: nama,
          deskripsi: deskripsi,
          tahun: tahun,
          fotografer: extra,
          kondisi: _selectedKondisi,
          lokasi: lokasi,
          urlGambar: urlGambar,
        );
      }

      if (widget.onSave != null) {
        widget.onSave!(newItem);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String extraLabel = 'Nama Pelukis';
    if (_selectedType == 'Patung') extraLabel = 'Nama Pematung';
    if (_selectedType == 'Fotografi') extraLabel = 'Nama Fotografer';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.koleksi == null
                          ? 'Tambah Koleksi Baru'
                          : 'Edit Koleksi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Nama Koleksi
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama Koleksi',
                    hintText: 'Contoh: Keris Majapahit',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama harus diisi' : null,
                ),
                SizedBox(height: 12),

                // Kategori
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    hintText: 'Contoh: Senjata Tradisional',
                    border: OutlineInputBorder(),
                  ),
                  items: _types.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: widget.koleksi == null
                      ? (value) {
                          setState(() {
                            _selectedType = value!;
                            _extraController.clear();
                          });
                        }
                      : null,
                ),
                SizedBox(height: 12),

                // Deskripsi
                TextFormField(
                  controller: _deskripsiController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    hintText: 'Deskripsi lengkap tentang koleksi...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 12),

                // Tahun dan Kondisi
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _tahunController,
                        decoration: InputDecoration(
                          labelText: 'Tahun',
                          hintText: 'Contoh: 1400-an',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return 'Tahun harus diisi';
                          if (int.tryParse(value) == null) return 'Harus angka';
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedKondisi,
                        decoration: InputDecoration(
                          labelText: 'Kondisi',
                          border: OutlineInputBorder(),
                        ),
                        items: _kondisiList.map((kondisi) {
                          return DropdownMenuItem(
                            value: kondisi,
                            child: Text(kondisi),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedKondisi = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Lokasi Penyimpanan
                TextFormField(
                  controller: _lokasiController,
                  decoration: InputDecoration(
                    labelText: 'Lokasi Penyimpanan',
                    hintText: 'Contoh: Ruang A - Rak 12',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),

                // URL Gambar
                TextFormField(
                  controller: _urlGambarController,
                  decoration: InputDecoration(
                    labelText: 'URL Gambar',
                    hintText: 'https://example.com/image.jpg',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),

                // Creator Name
                TextFormField(
                  controller: _extraController,
                  decoration: InputDecoration(
                    labelText: extraLabel,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? '$extraLabel harus diisi' : null,
                ),
                SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Batal'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(
                          'Tambah Koleksi',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
