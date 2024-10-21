
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:menatu_app/controllers/auth_service.dart';
import 'package:menatu_app/controllers/crud.dart';
import 'package:menatu_app/widget/bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Icon(Icons.person),
                    backgroundColor: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                      future: getUserName(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String?> snapshot) {
                        return Text('Hello ${snapshot.data}');
                      })
                ],
              ),
            ),
            ListTile(
              onTap: () {
                AuthService().logout();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Logged out')));
                Navigator.pushReplacementNamed(context, '/login');
              },
              leading: Icon(Icons.logout),
              title: Text('Logout'),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(0),
    );
  }
}
