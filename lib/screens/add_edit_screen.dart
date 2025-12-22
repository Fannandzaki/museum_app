import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // Tambahan Image Picker
import '../constants/color_constant.dart';
import '../models/koleksi_model.dart';
import '../widgets/koleksi_image.dart'; // Import widget gambar baru

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
  final _extraController = TextEditingController();
  final _lokasiController = TextEditingController();
  // Controller gambar kita hapus, ganti jadi variabel string path
  String _imagePath = '';

  String _selectedType = 'Lukisan';
  final List<String> _types = ['Lukisan', 'Patung', 'Fotografi'];

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

      // Isi path gambar dari data lama
      _imagePath = item.urlGambar;

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

  // Fungsi Ambil Gambar (Picker)
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Buka Galeri
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path; // Simpan path gambar
      });
    }
  }

  String get _extraLabel {
    if (_selectedType == 'Patung') return 'Nama Pematung';
    if (_selectedType == 'Fotografi') return 'Nama Fotografer';
    return 'Nama Pelukis';
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      // Validasi Gambar
      if (_imagePath.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Harap pilih gambar koleksi!'),
              backgroundColor: Colors.red),
        );
        return;
      }

      String id = _idController.text.isEmpty
          ? "ID-${DateTime.now().millisecondsSinceEpoch}"
          : _idController.text;
      String nama = _namaController.text;
      String deskripsi = _deskripsiController.text;
      int tahun = int.tryParse(_tahunController.text) ?? 0;
      String extra = _extraController.text;
      String lokasi = _lokasiController.text;

      Koleksi newItem;

      if (_selectedType == 'Lukisan') {
        newItem = Lukisan(
            id: id,
            nama: nama,
            deskripsi: deskripsi,
            tahun: tahun,
            pelukis: extra,
            lokasi: lokasi,
            urlGambar: _imagePath);
      } else if (_selectedType == 'Patung') {
        newItem = Patung(
            id: id,
            nama: nama,
            deskripsi: deskripsi,
            tahun: tahun,
            pematung: extra,
            lokasi: lokasi,
            urlGambar: _imagePath);
      } else {
        newItem = Fotografi(
            id: id,
            nama: nama,
            deskripsi: deskripsi,
            tahun: tahun,
            fotografer: extra,
            lokasi: lokasi,
            urlGambar: _imagePath);
      }

      if (widget.onSave != null) widget.onSave!(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
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
                Text(widget.koleksi == null ? 'Tambah Koleksi' : 'Edit Koleksi',
                    style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),

          // FORM
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- AREA UPLOAD GAMBAR BARU ---
                    _buildLabel("Foto Koleksi"),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: _imagePath.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate_outlined,
                                      size: 50, color: ColorConstant.primary),
                                  const Gap(8),
                                  Text("Klik untuk upload gambar",
                                      style: GoogleFonts.inter(
                                          color: Colors.grey)),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: KoleksiImage(
                                    imagePath: _imagePath, fit: BoxFit.cover),
                              ),
                      ),
                    ),
                    const Gap(8),
                    if (_imagePath.isNotEmpty)
                      Center(
                        child: TextButton.icon(
                          onPressed: _pickImage,
                          icon: Icon(Icons.refresh, size: 16),
                          label: Text("Ganti Foto"),
                        ),
                      ),
                    const Gap(20),
                    // -----------------------------

                    _buildLabel("Kategori"),
                    _buildDropdown(
                        _types,
                        _selectedType,
                        (v) => setState(() {
                              _selectedType = v!;
                              _extraController.clear();
                            })),
                    const Gap(16),
                    _buildLabel("Nama Koleksi"),
                    _buildTextField(_namaController, "Contoh: Keris",
                        Icons.museum_outlined),
                    const Gap(16),
                    Row(children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            _buildLabel("Tahun"),
                            _buildTextField(
                                _tahunController, "1400", Icons.calendar_today,
                                isNumber: true)
                          ])),
                      const Gap(16),
                    ]),
                    const Gap(16),
                    _buildLabel(_extraLabel),
                    _buildTextField(
                        _extraController, "Nama...", Icons.person_outline),
                    const Gap(16),
                    _buildLabel("Lokasi"),
                    _buildTextField(
                        _lokasiController, "Rak A", Icons.location_on_outlined),
                    const Gap(16),
                    _buildLabel("Deskripsi"),
                    _buildTextField(
                        _deskripsiController, "Jelaskan...", Icons.description,
                        maxLines: 3),
                    const Gap(40),
                  ],
                ),
              ),
            ),
          ),

          // TOMBOL SIMPAN
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5))
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
                child: Text('Simpan Data',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.bold)),
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
            color: ColorConstant.textTitle),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon,
      {bool isNumber = false, int maxLines = 1}) {
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
        fillColor: Colors.grey[50],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDropdown(
      List<String> items, String value, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(
                  value: e, child: Text(e, style: GoogleFonts.inter())))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
