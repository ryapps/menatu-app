import 'package:flutter/material.dart';
import 'package:menatu_app/controllers/laundry_controller.dart';
import 'package:menatu_app/models/Laundry.dart';
import 'package:menatu_app/views/memesan_laundry/detail_pemesanan.dart';
import 'package:menatu_app/widget/custom_list_view.dart';
import 'package:provider/provider.dart';

class DetailLaundry extends StatefulWidget {
  DetailLaundry({Key? key, required this.laundryId, required this.userId})
      : super(key: key);
  final int laundryId;
  final int userId;

  @override
  _DetailLaundryState createState() => _DetailLaundryState();
}

class _DetailLaundryState extends State<DetailLaundry>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = [
    Tab(text: 'Tentang'),
    Tab(text: 'Review'),
    Tab(text: 'Peta'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _selectedColor =
        Theme.of(context).colorScheme.tertiary.withOpacity(1);
    final _unselectedColor = Colors.black;

    return ChangeNotifierProvider(
      create: (_) => LaundryController()..fetchLaundryById(widget.laundryId),
      child: Consumer<LaundryController>(builder: (context, controller, child) {
        if (controller.isLoading) {
          return Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                  child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              )));
        }

        if (controller.error != null) {
          return Center(child: Text('Error: ${controller.error}'));
        }

        final laundry = controller.laundry;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(300.0),
            child: AppBar(
              flexibleSpace: Image.asset(
                'assets/img/img_laundry-big.png',
                fit: BoxFit.cover,
              ),
              title: null,
              backgroundColor: Colors.transparent,
              leading: Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  IconButton.filled(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              leadingWidth: 76,
              actions: [
                IconButton.filled(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  icon: Icon(Icons.share),
                  onPressed: () {},
                ),
                IconButton.filled(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  icon: Icon(Icons.favorite_outline),
                  onPressed: () {},
                ),
                SizedBox(width: 16),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Container(
                  margin: EdgeInsets.only(bottom: 45),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          'assets/img/img_laundry.png',
                          fit: BoxFit.cover,
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        thickness: 5,
                        indent: 2,
                      ),
                      itemCount: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            laundry?.namaLaundry ?? 'Laundry',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.yellow,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                laundry?.rating.toString() ?? '0.0',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 2),
                              Text(
                                  '(${laundry?.review.toString()} reviews)' ??
                                      '0' + 'reviews',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      laundry?.alamat ?? 'Tidak ada alamat',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    ),
                  ),
                  Divider(color: Colors.transparent),
                  TabBar(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    controller: _tabController,
                    tabs: _tabs,
                    labelColor: _selectedColor,
                    indicatorColor: _selectedColor,
                    unselectedLabelColor: _unselectedColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.43,
                    child: TabBarView(controller: _tabController, children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: CustomListView(
                                itemCount: 3,
                                itemWidth:
                                    MediaQuery.of(context).size.width * 0.65,
                                itemHeight:
                                    MediaQuery.of(context).size.height * 0.15,
                                scrollDirection: Axis.horizontal,
                                itemShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/icon/promo.png',
                                                width: 50,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                'Diskon laundry ${20 * (1 + index)}%, khusus cuci basah',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                          height: 2,
                                          color: Colors.grey,
                                          indent: 1,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Min. ${5 * (2 + index)} pakaian')
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    Container(),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text('Pemilik Laundry',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600))),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                      foregroundColor:
                                          Theme.of(context).primaryColor,
                                      backgroundColor: Colors.grey.shade300,
                                      child: Icon(
                                        Icons.person,
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Chelsea Alivia',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        laundry?.noTelepon ?? '',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.215,
                                  ),
                                  IconButton.filled(
                                    onPressed: () {},
                                    icon: Image.asset('assets/icon/chat.png'),
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.grey.shade300)),
                                  ),
                                  IconButton.filled(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.phone,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.grey.shade300)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text('Buka - Tutup',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600))),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.store,
                                    color: Theme.of(context).primaryColor,
                                    size: 28,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    laundry?.jadwal ?? '',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(),
                      ),
                      Container(
                        child: Column(),
                      )
                    ]),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.all(20),
            height: 50,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Theme.of(context).primaryColor),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)))),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          DetailPemesanan(
                        laundryId: widget.laundryId, userId: widget.userId
                      ),
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
                child: Text(
                  'Pesan Laundry Sekarang',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800),
                )),
          ),
        );
      }),
    );
  }
}

class LaundryController extends ChangeNotifier {
  final LaundryService _laundryService = LaundryService();
  Laundry? _laundry;
  bool _isLoading = false;
  String? _error;

  Laundry? get laundry => _laundry;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchLaundryById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _laundry = await _laundryService.getLaundryById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
