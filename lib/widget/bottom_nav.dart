import 'package:flutter/material.dart';
import 'dart:async';

class BottomNav extends StatefulWidget {
  BottomNav({required this.page, Key? key});
  int? page;
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  Future<void> getPage(int index) async {
    if (index == 0) {
      await Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      await Navigator.pushReplacementNamed(context, '/eksplor');
    } else if (index == 2) {
      await Navigator.pushReplacementNamed(context, '/transaksi');
    } else if (index == 3) {
      await Navigator.pushReplacementNamed(context, '/pesan');
    } else if (index == 4) {
      await Navigator.pushReplacementNamed(context, '/user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        height: 71,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
          selectedItemColor: Colors.white,
          selectedFontSize: 12.0, // Ukuran font item yang dipilih
          unselectedFontSize: 12.0,
          currentIndex: widget.page!,
          onTap: (int index) {
            getPage(index); // Pemanggilan fungsi async
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_filled,
                ),
                label: 'Home',
                backgroundColor:
                    Theme.of(context).bottomNavigationBarTheme.backgroundColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.location_on,
                ),
                label: 'Explor',
                backgroundColor:
                    Theme.of(context).bottomNavigationBarTheme.backgroundColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.receipt_long,
                ),
                label: 'Transaksi',
                backgroundColor:
                    Theme.of(context).bottomNavigationBarTheme.backgroundColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                ),
                label: 'Chat',
                backgroundColor:
                    Theme.of(context).bottomNavigationBarTheme.backgroundColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'User',
                backgroundColor:
                    Theme.of(context).bottomNavigationBarTheme.backgroundColor)
          ],
        ),
      ),
    );
  }
}
