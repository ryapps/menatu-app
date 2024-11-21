import 'package:flutter/material.dart';
import 'package:menatu_app/widget/bottom_nav.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            bottomNavigationBar: BottomNav(page: 2),

    );
  }
}