import 'package:flutter/material.dart';
import 'package:menatu_app/widget/bottom_nav.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    bottomNavigationBar: BottomNav(page: 1),
    );
  }
}