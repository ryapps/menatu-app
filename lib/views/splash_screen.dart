import 'package:flutter/material.dart';
import 'package:menatu_app/controllers/auth_service.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer untuk berpindah dari splash screen ke halaman utama setelah 3 detik
    Timer(Duration(seconds: 5), () {
      AuthService().isLoggedIn().then((value) async{
        if (value) {
          await Navigator.pushReplacementNamed(context, '/home');
        } else {
          await Navigator.pushReplacementNamed(context, '/onboarding');
        }
      });
    });
  }

  void _navigate() async {
    // Durasi splash screen
    await Future.delayed(Duration(seconds: 3));

    // Periksa status onboarding
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? onboardingCompleted = prefs.getBool('onboarding_completed');

    if (onboardingCompleted ?? false) {
      // Jika onboarding telah diselesaikan, langsung menuju HomePage
    Navigator.pushReplacementNamed(context, '/login');
    }
    // Jika onboarding belum diselesaikan, menuju OnboardingPage
    Navigator.pushReplacementNamed(context, '/onboarding');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).primaryColor, // Warna latar belakang splash screen
      body: Center(
          child: Image.asset(
        'assets/img/logo_menatu.png',
        width: 186,
      )),
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  @override

  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
