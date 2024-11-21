import 'package:flutter/material.dart';
import 'package:menatu_app/widget/bottom_nav.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            bottomNavigationBar: BottomNav(page: 4),

    );
  }
}