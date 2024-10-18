import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  getPage(index){
    
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      items: [
        
        BottomNavigationBarItem(icon: Icon(Icons.home_filled,), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.location_on,), label: 'Lokasi'),
        BottomNavigationBarItem(icon: Icon(Icons.library_books_outlined,), label: 'Transaksi'),
        BottomNavigationBarItem(icon: Icon(Icons.message,), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.person,), label: 'User')
    ]);
  }
}