import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/color_constant.dart';
import '../models/koleksi_model.dart';

class AddEditScreen extends StatefulWidget {
  final Koleksi? koleksi;
  final Function(Koleksi)? onSave;

  const AddEditScreen({super.key, this.koleksi, this.onSave});

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final _idController = TextEditingController();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _tahunController = TextEditingController();
  final _extraController =
      TextEditingController(); // Untuk Pelukis/Pematung/Fotografer
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

  // Label dinamis untuk input "Extra" sesuai kategori
  String get _extraLabel {
    if (_selectedType == 'Patung') return 'Nama Pematung';
    if (_selectedType == 'Fotografi') return 'Nama Fotografer';
    return 'Nama Pelukis';
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      String id = _idController.text.isEmpty
          ? "ID-${DateTime.now().millisecondsSinceEpoch}"
          : _idController.text;
      String nama = _namaController.text;
      String deskripsi = _deskripsiController.text;
      int tahun = int.tryParse(_tahunController.text) ?? 0;
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. HEADER (Mirip Project Smart)
          Container(
            padding:
                const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.koleksi == null ? 'Tambah Koleksi' : 'Edit Koleksi',
                  style: GoogleFonts.inter(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // 2. FORM SCROLLABLE
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown Kategori
                    _buildLabel("Kategori Koleksi"),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedType,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: ColorConstant.primary),
                          items: _types.map((type) {
                            return DropdownMenuItem(
                                value: type,
                                child: Text(type, style: GoogleFonts.inter()));
                          }).toList(),
                          onChanged: widget.koleksi == null
                              ? (value) {
                                  setState(() {
                                    _selectedType = value!;
                                    _extraController.clear();
                                  });
                                }
                              : null, // Disable change on Edit mode
                        ),
                      ),
                    ),
                    const Gap(20),

                    // Input Nama
                    _buildLabel("Nama Koleksi"),
                    _buildTextField(
                      controller: _namaController,
                      hint: "Contoh: Keris Majapahit",
                      icon: Icons.museum_outlined,
                    ),
                    const Gap(20),

                    // Input Tahun & Kondisi (Side by Side)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Tahun"),
                              _buildTextField(
                                controller: _tahunController,
                                hint: "1400",
                                icon: Icons.calendar_today,
                                isNumber: true,
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Kondisi"),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                height: 50, // Samakan tinggi dengan textfield
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedKondisi,
                                    isExpanded: true,
                                    items: _kondisiList.map((k) {
                                      return DropdownMenuItem(
                                          value: k,
                                          child: Text(k,
                                              style: GoogleFonts.inter(
                                                  fontSize: 14)));
                                    }).toList(),
                                    onChanged: (v) =>
                                        setState(() => _selectedKondisi = v!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),

                    // Input Extra (Pelukis/Pematung/dll)
                    _buildLabel(_extraLabel),
                    _buildTextField(
                      controller: _extraController,
                      hint: "Masukkan $_extraLabel",
                      icon: Icons.person_outline,
                    ),
                    const Gap(20),

                    // Lokasi
                    _buildLabel("Lokasi Penyimpanan"),
                    _buildTextField(
                      controller: _lokasiController,
                      hint: "Contoh: Ruang A - Rak 2",
                      icon: Icons.location_on_outlined,
                    ),
                    const Gap(20),

                    // URL Gambar
                    _buildLabel("URL Gambar"),
                    _buildTextField(
                      controller: _urlGambarController,
                      hint: "https://...",
                      icon: Icons.image_outlined,
                    ),
                    const Gap(20),

                    // Deskripsi
                    _buildLabel("Deskripsi Lengkap"),
                    _buildTextField(
                      controller: _deskripsiController,
                      hint: "Ceritakan sejarah koleksi ini...",
                      icon: Icons.description_outlined,
                      maxLines: 4,
                    ),
                    const Gap(40), // Space extra di bawah biar enak scroll
                  ],
                ),
              ),
            ),
          ),

          // 3. BOTTOM BUTTON (Sticky)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  'Simpan Data',
                  style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: ColorConstant.textTitle,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: GoogleFonts.inter(fontSize: 14),
      validator: (value) => value == null || value.isEmpty
          ? 'Field ini tidak boleh kosong'
          : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
        filled: true,
        fillColor:
            Colors.grey[50], // Warna background abu muda ala Smart Project
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Hilangkan garis border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: ColorConstant.primary, width: 1.5), // Garis saat diklik
        ),
      ),
    );
  }
}
