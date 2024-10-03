import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:menatu_app/views/onboarding/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingView extends StatelessWidget {
  OnBoardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: pages,
      onDone: () async {
        // Simpan status onboarding selesai
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboarding_completed', true);

        // Navigasi ke LoginPage
        Navigator.pushReplacementNamed(context, '/login');
      },
      onSkip: () async {
        // Simpan status onboarding selesai
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboarding_completed', true);

        // Navigasi ke LoginPage
        Navigator.pushReplacementNamed(context, '/login');
      },
      skipStyle: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent)),
      nextStyle: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent)),
      doneStyle: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent)),
      showSkipButton: true,
      skip: Padding(
        padding: const EdgeInsets.only(top: 200, right: 30),
        child: Text(
          'Lewati',
          style: TextStyle(
              color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      next: Padding(
        padding: const EdgeInsets.only(top: 200.0, left: 30),
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 25,
          child: const Icon(Icons.arrow_forward_rounded,color: Colors.white,)),
      ),
      showNextButton: true,
      done: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadiusDirectional.circular(10)),
        margin: EdgeInsets.only(top: 200),
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child:  Text("Ayo Mulai",
            style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white)),
      ),
      dotsDecorator: DotsDecorator(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey, width: 1)),
        color: Colors.white,
        spacing: EdgeInsets.only(bottom: 260, right: 5, left: 5),
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
