import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:menatu_app/controllers/auth_service.dart';
import 'package:menatu_app/controllers/geolocator_service.dart';
import 'package:menatu_app/widget/bottom_nav.dart';
import 'package:menatu_app/widget/carousel.dart';
import 'package:menatu_app/widget/custom_list_view.dart';
import 'package:menatu_app/widget/nearby_laundries.dart';
import 'package:menatu_app/widget/search_appbar.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, this.userId});
  final int? userId;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> imagePaths = [
    'assets/img/promo_img.png',
    'assets/img/promo_img.png',
    'assets/img/promo_img.png',
  ];
  Map<String, String> kategori = {
    'Cuci Basah': 'assets/icon/Washing_Machine.png',
    'Cuci Kering': 'assets/icon/Clothes_line.png',
    'Setrika': 'assets/icon/Iron_High_Temperature.png',
    'Karpet': 'assets/icon/Wallpaper_Roll.png',
    'Premium': 'assets/icon/VIP.png'
  };
  bool _isLoading = false; // Menandakan apakah sedang mengambil alamat
  String _address = 'Menunggu alamat..';

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<void> _fetchAddress() async {
    setState(() {
      _isLoading = true; // Mulai loading
    });

    String address = await GeolocatorService().getAddressFromCoordinates();

    setState(() {
      _isLoading = false;
      _address = address;
// Selesai loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       DrawerHeader(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             CircleAvatar(
      //               child: Icon(Icons.person),
      //               backgroundColor: Colors.grey,
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //           ],
      //         ),
      //       ),
      //       ListTile(
      //         onTap: () {
      //           AuthService().logout();
      //           ScaffoldMessenger.of(context)
      //               .showSnackBar(SnackBar(content: Text('Logged out')));
      //           Navigator.pushReplacementNamed(context, '/login');
      //         },
      //         leading: Icon(Icons.logout),
      //         title: Text('Logout'),
      //       )
      //     ],
      //   ),
      // ),
      appBar: AddressSearchAppBar(
          address: _isLoading ? 'Memuat alamat' : _address,
          onSearch: (query) {
            print('Mencari: $query');
          }),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(color: Colors.transparent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Promo Spesial',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Lihat Semua',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CarouselWidget(imagePaths: imagePaths),
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Kategori',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomListView(
                    itemCount: kategori.length,
                    itemWidth: 60.0,
                    icon: kategori,
                    jenis: 'kategori',
                    scrollDirection: Axis.horizontal,
                    itemShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    itemBuilder: (context, index) {
                      String key = kategori.keys.elementAt(index);
                      String value = kategori[key]!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            value,
                            width: 50,
                            height: 50,
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => Container(
                      width: 5.0,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Laundry Terdekat',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Lihat Semua',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      )
                    ],
                  ),
                ),
                SizedBox(
                    height: 208,
                    child: NearbyLaundriesWidget(userId: widget.userId ?? 0)),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Informasi Menarik',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Lihat Semua',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: CustomListView(
                    itemCount: 5,
                    itemWidth: MediaQuery.of(context).size.width * 0.75,
                    itemHeight: MediaQuery.of(context).size.height * 0.37,
                    scrollDirection: Axis.horizontal,
                    itemShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/img/img_info.png',
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Column(
                                children: [
                                  Text(
                                    '5 Cara Merawat Pakaianmu! No 1 paling ampuh!',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.visibility,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 25,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              '101x Dilihat',
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                Theme.of(context).primaryColor),
                                        child: Text(
                                          'Selengkapnya',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Container(),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: BottomNav(page: 0),
    );
  }
}
