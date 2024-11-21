import 'dart:async';

import 'package:flutter/material.dart';
import 'package:menatu_app/models/Laundry.dart';
import 'package:menatu_app/controllers/laundry_controller.dart'; // File di mana fungsi `fetchNearbyLaundries` berada
import 'package:menatu_app/controllers/geolocator_service.dart';
import 'package:menatu_app/views/memesan_laundry/detail_laundry.dart';
import 'package:menatu_app/widget/custom_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NearbyLaundriesWidget extends StatefulWidget {
  NearbyLaundriesWidget({super.key, required this.userId});
  final int userId;
  @override
  _NearbyLaundriesWidgetState createState() => _NearbyLaundriesWidgetState();
}

class _NearbyLaundriesWidgetState extends State<NearbyLaundriesWidget> {
  late Future<List<Laundry>> futureLaundries = Future.value([]);
  GeolocatorService geolocatorService = GeolocatorService();
  LaundryService laundryService = LaundryService();
  late List<int> idLaundry = [];
  @override
  @override
  void initState() {
    super.initState();
    geolocatorService.getCurrentLocation().then((position) {
      setState(() {
        futureLaundries = laundryService.fetchNearbyLaundries(
            position.latitude, position.longitude);
      });
    }).catchError((error) {
      // Tangani error, misal izin lokasi tidak diberikan
      print('Error getting location: $error');
    });
    // Timer.periodic(Duration(seconds: 3), (timer) {
    //   // Gantikan ID laundry sesuai dengan data yang dibutuhkan
    //   if (idLaundry.isNotEmpty) {
    //     for (int id in idLaundry) {
    //       LaundryService().updateLaundryStatus(id);
    //     }
    //   } else {
    //     print('Data idLaundry kosong');
    //   }
    //   ;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Laundry>>(
      future: futureLaundries,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Laundry> laundries = snapshot.data!;
          // idLaundry = laundries.map((laundry) => laundry.id).toList();
          return CustomListView(
            itemCount: laundries.length,
            itemWidth: MediaQuery.of(context).size.width * 0.75,
            itemHeight: MediaQuery.of(context).size.height * 0.4,
            scrollDirection: Axis.horizontal,
            itemShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'assets/img/img_laundry.png',
                                width: 75,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary
                                        .withOpacity(1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Cuci Basah',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          '${4 + index} antrean',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        )),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.14,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.star_rounded,
                                            color: Colors.yellow,
                                          ),
                                          Text(
                                              '${laundries[index].rating.toString()}')
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                laundries[index].namaLaundry.length > 20
                                    ? Text(
                                        laundries[index]
                                            .namaLaundry
                                            .substring(0, 17),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            overflow: TextOverflow.ellipsis),
                                      )
                                    : Text(
                                        laundries[index].namaLaundry,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900),
                                      ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.grey.shade300,
                                      size: 20,
                                    ),
                                    laundries[index].alamat!.length > 20
                                        ? Text(
                                            '${laundries[index].alamat!.substring(0, 20)}',
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 12),
                                          )
                                        : Text('${laundries[index].alamat}',
                                            style: TextStyle(fontSize: 10)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Divider(
                              color: Colors.grey,
                              height: 2,
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.map,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${laundries[index].distance!.toStringAsFixed(2)} km',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${laundries[index].status}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          DetailLaundry(
                        laundryId: laundries[index].id!, userId: widget.userId
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
              );
            },
            separatorBuilder: (context, index) => Container(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Loading state
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
