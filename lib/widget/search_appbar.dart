import 'package:flutter/material.dart';

class AddressSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String address;
  final ValueChanged<String> onSearch;

  AddressSearchAppBar({required this.address, required this.onSearch});

  @override
  Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      child: AppBar(  
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alamat',style: TextStyle(fontSize: 14,color: Colors.white),),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.location_pin,size: 20,color: Colors.white,),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Expanded(
                      child: Text(
                        address,
                        style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.02),
            child: IconButton(onPressed: (){}, icon: Icon(Icons.notifications,color: Colors.white,size: 25)),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            margin: EdgeInsets.all(screenWidth * 0.06),
            height: 45,
            child: TextField(
              onChanged: onSearch,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w500,fontSize: 14),
                hintText: 'Cari Laundry',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 8.0), // Atur padding vertikal
      
                prefixIcon: Icon(Icons.search_rounded, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height * 0.2); // Ketinggian app bar
}
