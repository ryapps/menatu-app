import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:group_button/group_button.dart';
import 'package:menatu_app/controllers/geolocator_service.dart';
import 'package:menatu_app/views/memesan_laundry/pembayaran.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPemesanan extends StatefulWidget {
  DetailPemesanan({Key? key, required this.laundryId, required this.userId})
      : super(key: key);
  final int laundryId;
  final int userId;
  @override
  _DetailPemesananState createState() => _DetailPemesananState();
}

class _DetailPemesananState extends State<DetailPemesanan> {
  bool _isLoading = false; // Menandakan apakah sedang mengambil alamat
  String _selectedValueCuci = ''; // Menyimpan nilai pilihan
  String _selectedValueKain = ''; // Menyimpan nilai pilihan
  List<String> _items =
      []; // Menyimpan daftar item berdasarkan layanan yang dipilih
  List<String> _imgItems = [];
  List<int> _price = [];
  Map<String, int> _itemCounts = {};
  int _totalPrice = 0; // Menyimpan total harga

  void initState() {
    super.initState();
  }

  Future<void> _saveOrderDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Simpan data sebagai JSON string
    List<String> filteredItems = [];
    List<String> filteredImgItems = [];
    List<int> filteredPrice = [];
    List<int> filteredItemCounts = [];

    for (int i = 0; i < _items.length; i++) {
      if (_itemCounts[_items[i]]! > 0) {
        filteredItems.add(_items[i]);
        filteredImgItems.add(_imgItems[i]);
        filteredPrice.add(_price[i]);
        filteredItemCounts.add(_itemCounts[_items[i]]!);
      }
    }

    // Simpan data yang sudah difilter
    await prefs.setString('washType', _selectedValueCuci);
    await prefs.setString('items', jsonEncode(filteredItems));
    await prefs.setString('imgItems', jsonEncode(filteredImgItems));
    await prefs.setString('price', jsonEncode(filteredPrice));
    await prefs.setString('itemCounts', jsonEncode(filteredItemCounts));
    await prefs.setInt('totalPrice', _totalPrice);
  }

  bool hasItemsWithCount() {
    return _itemCounts.values.any((count) => count > 0);
  }

  // Fungsi untuk memperbarui total harga
  void _updateTotalPrice() {
    int total = 0;
    for (int i = 0; i < _items.length; i++) {
      total += (_price[i] * (_itemCounts[_items[i]] ?? 0));
    }
    setState(() {
      _totalPrice = total;
    });
  }

  Future<String> _getAddress() async {
    setState(() {
      _isLoading = true; // Mulai loading
    });

    String address = await GeolocatorService().getAddressFromCoordinates();

    setState(() {
      _isLoading = false; // Selesai loading
    });

    return address; // Mengembalikan alamat yang diambil
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Detail Pemesanan',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        leading: Row(
          children: [
            SizedBox(
              width: 16,
            ),
            IconButton.filled(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        leadingWidth: 64,
        actions: [
          IconButton(
              icon: Icon(
                Icons.help_outline,
                size: 28,
              ),
              onPressed: () {}),
          SizedBox(
            width: 16,
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Mau Cuci Apa?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
          SizedBox(
            height: 10,
          ),
          // Bagian Tab Pelayanan
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: GroupButton<String>(
              isRadio: true, // Hanya satu tombol yang dapat dipilih
              buttons: ["Cuci Basah"], // Daftar tombol
              onSelected: (value, index, isSelected) {
                setState(() {
                  _selectedValueCuci =
                      value; // Menyimpan nilai tombol yang dipilih
                });
              },
              buttonBuilder: (selected, value, context) => Container(
                margin: value == "Cuci Basah"
                    ? EdgeInsets.only(left: 20)
                    : EdgeInsets.all(0),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: selected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Divider(
              height: 1,
              color: Colors.grey,
            ),
          ),

          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Mau kain yang mana?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
          SizedBox(
            height: 10,
          ),
          // Bagian Tab Jenis Kain
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: GroupButton<String>(
              isRadio: true, // Hanya satu tombol yang dapat dipilih
              buttons: [
                "Satuan",
                "Kiloan",
                "Aksesoris",
                "Tempat Tidur",
                "Tas & Sepatu"
              ], // Daftar tombol
              onSelected: (value, index, isSelected) {
                setState(() {
                  _selectedValueKain =
                      value; // Menyimpan nilai tombol yang dipilih
                  if (_selectedValueKain == "Satuan") {
                    _items = ['Kaos', 'Celana Jeans', 'Kemeja', 'Jas'];
                    _imgItems = [
                      'img_kaos.png',
                      'img_jeans.png',
                      'img_kemeja.png',
                      'img_jas.png'
                    ];
                    _price = [5000, 7000, 7000, 10000];
                    for (var item in _items) {
                      _itemCounts[item] = 0;
                    }
                  } else {
                    _items = [];
                    _imgItems = [];
                    _price = [];
                    _itemCounts.clear();
                  }
                  _updateTotalPrice();
                });
              },
              buttonBuilder: (selected, value, context) => Container(
                margin: value == "Satuan"
                    ? EdgeInsets.only(left: 20)
                    : value == "Tas & Sepatu"
                        ? EdgeInsets.only(right: 20)
                        : EdgeInsets.all(0),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: selected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Divider(
              height: 1,
              color: Colors.grey,
            ),
          ),
          if (_items.isNotEmpty) ...[
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _items[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    leading: Image.asset(
                      'assets/img/${_imgItems[index]}',
                      fit: BoxFit.cover,
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        'Rp${_price[index]}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          iconSize: 28,
                          onPressed: () {
                            setState(() {
                              if (_itemCounts[_items[index]]! > 0) {
                                _itemCounts[_items[index]] =
                                    _itemCounts[_items[index]]! - 1;
                                _updateTotalPrice();
                              }
                            });
                          },
                        ),
                        Text(
                          '${_itemCounts[_items[index]]}',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          iconSize: 28,
                          onPressed: () {
                            setState(() {
                              _itemCounts[_items[index]] =
                                  _itemCounts[_items[index]]! + 1;
                              _updateTotalPrice();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: hasItemsWithCount()
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              height: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total', style: TextStyle(fontSize: 16)),
                      Text(
                        'Rp$_totalPrice',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading =
                            true; // Tampilkan indikator loading saat mulai mengambil alamat
                      });

                      String address = await _getAddress(); // Ambil alamat
                      await _saveOrderDetails();
                      setState(() {
                        _isLoading =
                            false; // Sembunyikan indikator loading setelah alamat didapat
                      });

                      // Aksi setelah alamat berhasil diambil
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  Pembayaran(
                            address: address,
                            laundryId: widget.laundryId, userId: widget.userId
                          ), // Pass the address here
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                          transitionDuration: Duration(milliseconds: 500),
                        ),
                      );
                    },
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ) // Tampilkan indikator loading saat mengambil alamat
                        : Text(
                            'Atur Pembayaran',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                    style: ButtonStyle(
                      padding: _isLoading
                          ? MaterialStateProperty.all(EdgeInsets.all(5))
                          : MaterialStateProperty.all(EdgeInsets.all(15)),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                    ),
                  )
                ],
              ),
            )
          : SizedBox(
              height: 2,
            ),
    );
  }
}
