import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:menatu_app/controllers/order_service.dart';
import 'package:menatu_app/views/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pembayaran extends StatefulWidget {
  Pembayaran(
      {super.key,
      required this.address,
      required this.laundryId,
      required this.userId});
  String address;
  final int laundryId;
  final int userId;
  @override
  State<Pembayaran> createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
  int _selectedOption = 1; // Default pilihan yang dipilih
  final formKey = GlobalKey<FormState>();
  PesananService _orderNote = PesananService();
  final GroupButtonController _timeJemputController = GroupButtonController(
    selectedIndex: 0, // Mengatur pilihan awal pada indeks pertama
  );
  final GroupButtonController _timeAntarController = GroupButtonController(
    selectedIndex: 0, // Mengatur pilihan awal pada indeks pertama
  );

  String? _selectedValueWaktuJemput;
  String? _selectedValueWaktuAntar;
  final _phoneController = TextEditingController();
  final List<Map<String, dynamic>> _options = [
    {
      'title': 'Express',
      'description': 'Laundry anda diprioritaskan',
      'duration': '3 jam - 24 jam',
      'price': 5000,
    },
    {
      'title': 'Regular',
      'description': '',
      'duration': '2 hari - 4 hari',
      'price': 7000,
    },
  ];
  TextEditingController _tanggalJemputController = TextEditingController();
  TextEditingController _tanggalAntarController = TextEditingController();

  // Fungsi untuk memilih tanggal
  Future<void> _pilihTanggalJemput(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _tanggalJemputController.text = formattedDate;
      });
    }
  }

  Future<void> _pilihTanggalAntar(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _tanggalAntarController.text = formattedDate;
      });
    }
  }

  List<String> items = [];
  List<String> imgItems = [];
  List<int> price = [];
  List<int> itemCounts = [];
  int totalPrice = 0;
  String washType = '';
  int serviceCost = 0;
  int payTotal = 0;

  bool _isLoading = false;

  void _updateTotalPrice() {
    int total = 0;
    for (int i = 0; i < items.length; i++) {
      total += (price[i] * (itemCounts[i] ?? 0));
    }
    setState(() {
      totalPrice = total;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadOrderDetails(); // Ambil data dari Shared Preferences saat widget diinisialisasi
    _selectedValueWaktuJemput = '07:00 - 10:00'; // Set nilai awal
    _selectedValueWaktuAntar = '07:00 - 10:00'; // Set nilai awal
  }

  bool hasItemsWithCount() {
    return itemCounts.any((count) => count > 0);
  }

  Future<void> _loadOrderDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil data dan konversikan dari JSON string ke List
    setState(() {
      washType = prefs.getString('washType') ?? '';
      items = List<String>.from(jsonDecode(prefs.getString('items') ?? '[]'));
      imgItems =
          List<String>.from(jsonDecode(prefs.getString('imgItems') ?? '[]'));
      price = List<int>.from(jsonDecode(prefs.getString('price') ?? '[]'));
      itemCounts =
          List<int>.from(jsonDecode(prefs.getString('itemCounts') ?? '[]'));
      totalPrice = prefs.getInt('totalPrice') ?? 0;
    });
  }

  Future<void> _submitForm() async {
    await showConfirmationDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    serviceCost = _options[1]['price'];
    payTotal = totalPrice + serviceCost;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Pembayaran',
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
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Alamat penjemputan',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                            0.5), // Warna bayangan dengan transparansi
                        spreadRadius: 0, // Jangkauan bayangan
                        blurRadius: 3, // Kekaburan bayangan
                        offset: Offset(0, 0), // Posisi bayangan ke bawah
                      ),
                    ]),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 275,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: Text(
                            widget.address,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(10),
                              side: BorderSide(
                                color: Theme.of(context)
                                    .primaryColor, // Warna border
                                width: 2, // Ketebalan border
                              ),
                            ),
                            child: Text(
                              'Ganti Lokasi',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            )),
                        OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(10),
                              side: BorderSide(
                                color: Colors.grey, // Warna border
                                width: 1, // Ketebalan border
                              ),
                            ),
                            child: Text(
                              'Catatan',
                              style: TextStyle(color: Colors.grey),
                            )),
                        OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(10),
                              side: BorderSide(
                                color: Colors.grey, // Warna border
                                width: 1, // Ketebalan border
                              ),
                            ),
                            child: Text(
                              'Detail alamat',
                              style: TextStyle(color: Colors.grey),
                            )),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Alamat pengantaran',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                            0.5), // Warna bayangan dengan transparansi
                        spreadRadius: 0, // Jangkauan bayangan
                        blurRadius: 3, // Kekaburan bayangan
                        offset: Offset(0, 0), // Posisi bayangan ke bawah
                      ),
                    ]),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 275,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: Text(
                            widget.address,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(10),
                              side: BorderSide(
                                color: Theme.of(context)
                                    .primaryColor, // Warna border
                                width: 2, // Ketebalan border
                              ),
                            ),
                            child: Text(
                              'Ganti Lokasi',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            )),
                        OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(10),
                              side: BorderSide(
                                color: Colors.grey, // Warna border
                                width: 1, // Ketebalan border
                              ),
                            ),
                            child: Text(
                              'Catatan',
                              style: TextStyle(color: Colors.grey),
                            )),
                        OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(10),
                              side: BorderSide(
                                color: Colors.grey, // Warna border
                                width: 1, // Ketebalan border
                              ),
                            ),
                            child: Text(
                              'Detail alamat',
                              style: TextStyle(color: Colors.grey),
                            )),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Kecepatan pelayanan',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: GroupButton(
                  isRadio: true,
                  buttons: List.generate(
                      _options.length, (index) => _options[index]['title']),
                  onSelected: (value, index, isSelected) {
                    setState(() {
                      _selectedOption = index;
                      serviceCost = _options[_selectedOption]['price'];
                    });
                  },
                  buttonBuilder: (selected, value, context) {
                    int index = _options
                        .indexWhere((option) => option['title'] == value);
                    var option = _options[index];

                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option['title'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  SizedBox(width: 7),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      option['duration'],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                  index != 0
                                      ? SizedBox(
                                          width: 24,
                                        )
                                      : SizedBox(width: 16.7),
                                  Text(
                                    option['price'].toString(),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    _selectedOption == index
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: _selectedOption == index
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                              option['description'] != ''
                                  ? SizedBox(
                                      height: 5,
                                    )
                                  : SizedBox(
                                      height: 0,
                                    ),
                              Row(
                                children: [
                                  if (option['description'] != '')
                                    Text(
                                      option['description'],
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (index != _options.length - 1)
                          Divider(
                            color: Colors.grey,
                            height: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Atur tanggal dan waktu',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                            0.5), // Warna bayangan dengan transparansi
                        spreadRadius: 0, // Jangkauan bayangan
                        blurRadius: 3, // Kekaburan bayangan
                        offset: Offset(0, 0), // Posisi bayangan ke bawah
                      ),
                    ]),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Pilih tanggal dan waktu penjemputan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextFormField(
                        controller: _tanggalJemputController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Pilih tanggal',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal harus dipilih';
                          }
                          return null;
                        },
                        onTap: () => _pilihTanggalJemput(context),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: GroupButton<String>(
                        isRadio: true, // Hanya satu tombol yang dapat dipilih
                        controller: _timeJemputController,
                        buttons: [
                          '07:00 - 10:00',
                          '10:00 - 13:00',
                          '13:00 - 16:00',
                          '16:00 - 18:00'
                        ], // Daftar tombol
                        onSelected: (value, index, isSelected) {
                          setState(() {
                            _selectedValueWaktuJemput =
                                value; // Menyimpan nilai tombol yang dipilih
                          });
                        },
                        buttonBuilder: (selected, value, context) {
                          return Container(
                            margin: value == "07:00 - 10:00"
                                ? EdgeInsets.only(left: 15)
                                : value == '16:00 - 18:00'
                                    ? EdgeInsets.only(right: 15)
                                    : EdgeInsets.all(0),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
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
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                            0.5), // Warna bayangan dengan transparansi
                        spreadRadius: 0, // Jangkauan bayangan
                        blurRadius: 3, // Kekaburan bayangan
                        offset: Offset(0, 0), // Posisi bayangan ke bawah
                      ),
                    ]),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Pilih tanggal dan waktu pengantaran',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextFormField(
                        controller: _tanggalAntarController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Pilih tanggal',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal harus dipilih';
                          }
                          return null;
                        },
                        onTap: () => _pilihTanggalAntar(context),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: GroupButton<String>(
                        controller: _timeAntarController,
                        isRadio: true, // Hanya satu tombol yang dapat dipilih
                        buttons: [
                          '07:00 - 10:00',
                          '10:00 - 13:00',
                          '13:00 - 16:00',
                          '16:00 - 18:00'
                        ], // Daftar tombol
                        onSelected: (value, index, isSelected) {
                          setState(() {
                            _selectedValueWaktuAntar =
                                value; // Menyimpan nilai tombol yang dipilih
                          });
                        },
                        buttonBuilder: (selected, value, context) => Container(
                          margin: value == "07:00 - 10:00"
                              ? EdgeInsets.only(left: 15)
                              : value == '16:00 - 18:00'
                                  ? EdgeInsets.only(right: 15)
                                  : EdgeInsets.all(0),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
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
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  washType,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: items.length == 1
                    ? 100
                    : items.length == 2
                        ? 150
                        : items.length == 3
                            ? 250
                            : items.length == 4
                                ? 300
                                : 20,
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        items[index],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: Image.asset(
                        'assets/img/${imgItems[index]}',
                        fit: BoxFit.cover,
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          'Rp${price[index]}',
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
                                if (itemCounts[index]! > 0) {
                                  itemCounts[index] = itemCounts[index]! - 1;
                                  _updateTotalPrice();
                                }
                              });
                            },
                          ),
                          Text(
                            '${itemCounts[index]}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            iconSize: 28,
                            onPressed: () {
                              setState(() {
                                itemCounts[index] = itemCounts[index]! + 1;
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mau tambah pakaian lagi?',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text('Masih bisa kok.')
                      ],
                    ),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(10),
                          side: BorderSide(
                            color:
                                Theme.of(context).primaryColor, // Warna border
                            width: 1, // Ketebalan border
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Tambah',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Ringkasan pembayaran',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                            0.5), // Warna bayangan dengan transparansi
                        spreadRadius: 0, // Jangkauan bayangan
                        blurRadius: 3, // Kekaburan bayangan
                        offset: Offset(0, 0), // Posisi bayangan ke bawah
                      ),
                    ]),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Harga'), Text(totalPrice.toString())],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Biaya pelayanan dan pengiriman'),
                        Text(serviceCost.toString())
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total pembayaran',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          payTotal.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                            0.5), // Warna bayangan dengan transparansi
                        spreadRadius: 0, // Jangkauan bayangan
                        blurRadius: 3, // Kekaburan bayangan
                        offset: Offset(0, 0), // Posisi bayangan ke bawah
                      ),
                    ]),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icon/promo.png',
                          fit: BoxFit.cover,
                          width: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Cek Promo Menarik',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_circle_right,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 30,
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: hasItemsWithCount()
          ? Container(
              margin: EdgeInsets.all(20),
              height: 106,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icon/Subtract.png',
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tunai',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                payTotal.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                        ],
                      ),
                      Transform.scale(
                        scale:
                            0.8, // Ubah skala (misalnya 0.8 untuk ukuran 80% dari ukuran asli)
                        child: IconButton.filled(
                          onPressed: () {},
                          icon: Icon(Icons.more_horiz),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(Size(
                              MediaQuery.of(context).size.width * 0.9, 48)),
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).primaryColor),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)))),
                      onPressed: () async {
                        if (_selectedOption == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Pilih kecepatan pelayanan terlebih dahulu')),
                          );
                        } else if (formKey.currentState!.validate()) {
                          _submitForm();
                        }
                      },
                      child: Text(
                        'Pesan dan jemput sekarang',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800),
                      )),
                ],
              ),
            )
          : SizedBox(
              height: 2,
            ),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  Future<void> showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Agar dialog tidak bisa ditutup dengan menekan di luar dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin melanjutkan aksi ini?'),
          actions: <Widget>[
            // Tombol Batal
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: Text(
                'Batal',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            // Tombol Konfirmasi
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
              ),
              onPressed: () async {
                // Jika form valid dan opsi sudah dipilih, lanjutkan pengiriman form
                if (_selectedOption == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Pilih kecepatan pelayanan terlebih dahulu')),
                  );
                } else if (formKey.currentState!.validate()) {
                  // Tampilkan loading dialog
                  showLoadingDialog(context);

                  // Proses pengiriman data (misalnya, panggil API atau fungsi lainnya)
                  await _orderNote.createPesanan(
                    idPelanggan: widget.userId,
                    idLaundry: widget.laundryId,
                    tanggalPesan: _tanggalJemputController.text,
                    totalHarga: payTotal,
                    statusPesanan: 'proses',
                  );

                  // Tutup dialog loading setelah proses selesai
                  Navigator.of(context).pop(); // Menutup dialog loading
                  // Menampilkan snackbar jika pengiriman sukses
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Form submitted successfully')),
                  );
                  Navigator.popUntil(
                      context, ModalRoute.withName('/home'));
                  // Menutup dialog konfirmasi
                }
              },
              child: Text(
                'Yakin',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Agar dialog tidak bisa ditutup dengan menekan di luar dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ),
          content: SizedBox(
              height: 200,
              child: Center(child: Text('Pesanan masih diproses'))),
        );
      },
    );
  }

  @override
  void dispose() {
    _tanggalJemputController.dispose();
    _tanggalAntarController.dispose();

    super.dispose();
  }
}
