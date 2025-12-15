import 'package:flutter/material.dart';
import '../models/koleksi_model.dart';
import 'add_edit_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
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
      final matchesCategory =
          _selectedCategory == 'Semua Kategori' ||
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
        onEdit: () {
          Navigator.pop(context);
          _showEditDialog(item, index);
        },
        onDelete: () {
          Navigator.pop(context);
          _showDeleteConfirmation(index);
        },
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        icon: Icon(Icons.warning_rounded, color: Colors.red, size: 48),
        title: Text('Hapus Koleksi'),
        content: Text(
          'Apakah Anda yakin ingin menghapus koleksi "${item.nama}"? Data yang sudah dihapus tidak dapat dikembalikan.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                daftarKoleksi.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Koleksi berhasil dihapus')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Museum Collection',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Sistem Manajemen Koleksi Barang Museum',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: Colors.blue,
        icon: Icon(Icons.add),
        label: Text('Tambah Koleksi'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              SearchBar(
                hintText:
                    'Cari koleksi berdasarkan nama, kategori, atau deskripsi...',
                leading: Icon(Icons.search),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Category Filter
              Align(
                alignment: Alignment.centerRight,
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  underline: SizedBox(),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 8),

              // Count
              Text(
                'Menampilkan ${_filteredItems.length} dari ${daftarKoleksi.length} koleksi',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(height: 16),

              // Grid Items
              _filteredItems.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Tidak ada koleksi',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final realIndex = daftarKoleksi.indexWhere(
                          (e) => e.id == item.id,
                        );

                        return GestureDetector(
                          onTap: () => _showDetailDialog(item, realIndex),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    item.urlGambar,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, error, stackTrace) =>
                                        Container(
                                          height: 100,
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                          ),
                                        ),
                                  ),
                                ),
                                // Content
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.nama,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item.kategori,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getConditionColor(
                                              item.kondisi,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            item.kondisi,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
