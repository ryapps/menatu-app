import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav(int i, {super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  getPage(index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/lokasi');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/transaksi');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/chat');
    } else if (index == 4) {
      Navigator.pushReplacementNamed(context, '/user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        onTap: getPage,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.location_on,
              ),
              label: 'Lokasi'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.library_books_outlined,
              ),
              label: 'Transaksi'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
              ),
              label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'User')
        ]);
  }
}
