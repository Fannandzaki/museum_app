import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/color_constant.dart';
import '../models/koleksi_model.dart';
import 'add_edit_screen.dart';
import 'detail_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isAdmin; // Menerima status apakah user ini admin atau bukan

  const HomeScreen({super.key, required this.isAdmin});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Semua Kategori';
  final List<String> _categories = [
    'Semua Kategori',
    'Lukisan',
    'Patung',
    'Fotografi',
  ];

  List<Koleksi> get _filteredItems {
    return daftarKoleksi.where((item) {
      final matchesSearch =
          item.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.deskripsi.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Semua Kategori' ||
          item.kategori == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditScreen(
        onSave: (newItem) {
          setState(() {
            daftarKoleksi.add(newItem);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDetailDialog(Koleksi item, int index) {
    showDialog(
      context: context,
      builder: (context) => DetailScreen(
        koleksi: item,
        // LOGIKA PENTING:
        // Jika Admin, kirim fungsi Edit & Delete.
        // Jika User biasa, kirim 'null' (biar tombolnya hilang).
        onEdit: widget.isAdmin
            ? () {
                Navigator.pop(context);
                _showEditDialog(item, index);
              }
            : null,
        onDelete: widget.isAdmin
            ? () {
                Navigator.pop(context);
                _showDeleteConfirmation(index);
              }
            : null,
      ),
    );
  }

  void _showEditDialog(Koleksi item, int index) {
    showDialog(
      context: context,
      builder: (context) => AddEditScreen(
        koleksi: item,
        onSave: (updatedItem) {
          setState(() {
            daftarKoleksi[index] = updatedItem;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDeleteConfirmation(int index) {
    final item = daftarKoleksi[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Koleksi'),
        content: Text('Hapus "${item.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => daftarKoleksi.removeAt(index));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // Ubah judul tergantung role
              widget.isAdmin ? 'Admin Dashboard' : 'Katalog Museum',
              style: GoogleFonts.inter(
                color: ColorConstant.textTitle,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              widget.isAdmin
                  ? 'Kelola koleksi museum'
                  : 'Jelajahi koleksi bersejarah',
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: _logout,
          ),
        ],
      ),
      // Tombol Tambah HANYA muncul jika isAdmin = true
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton.extended(
              onPressed: _showAddDialog,
              backgroundColor: ColorConstant.primary,
              icon: Icon(Icons.add, color: Colors.white),
              label:
                  Text('Tambah', style: GoogleFonts.inter(color: Colors.white)),
            )
          : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Cari koleksi...',
                    hintStyle: GoogleFonts.inter(color: Colors.grey),
                    prefixIcon:
                        Icon(Icons.search, color: ColorConstant.primary),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Filter Category
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    underline: SizedBox(),
                    items: _categories
                        .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c, style: GoogleFonts.inter())))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v!),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Grid Items
              _filteredItems.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Text("Tidak ada data",
                            style: GoogleFonts.inter(color: Colors.grey)),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final realIndex = daftarKoleksi.indexOf(item);

                        return GestureDetector(
                          onTap: () => _showDetailDialog(item, realIndex),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.network(
                                      item.urlGambar,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: Colors.grey[200],
                                        child: Center(
                                            child: Icon(Icons.broken_image,
                                                color: Colors.grey)),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.nama,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: ColorConstant.textTitle,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        item.kategori,
                                        style: GoogleFonts.inter(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
