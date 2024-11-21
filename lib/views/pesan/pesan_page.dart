import 'package:flutter/material.dart';
import 'package:menatu_app/widget/bottom_nav.dart';

class PesanPage extends StatefulWidget {
  const PesanPage({super.key});

  @override
  State<PesanPage> createState() => _PesanPageState();
}

class _PesanPageState extends State<PesanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            bottomNavigationBar: BottomNav(page: 3),
    );
  }
}