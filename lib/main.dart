import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menatu_app/views/home/home_page.dart';
import 'package:menatu_app/views/login/login_page.dart';
import 'package:menatu_app/views/login/signup_page.dart';
import 'package:menatu_app/views/onboarding/onboarding_widget.dart';
import 'package:menatu_app/views/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? onboardingCompleted = prefs.getBool('onboarding_completed');

  runApp(MyApp(onboardingCompleted: onboardingCompleted ?? false));
}

class MyApp extends StatelessWidget {
  final bool onboardingCompleted;

  const MyApp({required this.onboardingCompleted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(),
          primaryColor: Color.fromRGBO(1, 138, 144, 1),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Color.fromRGBO(240, 28, 61, 1),
              surface: Color.fromRGBO(233, 221, 208, 1),
              tertiary: Color.fromRGBO(0, 203, 206, 1)),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => SplashScreen(),
          '/onboarding': (context) => OnBoardingView(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/home': (context) => HomePage()
        });
  }
}

