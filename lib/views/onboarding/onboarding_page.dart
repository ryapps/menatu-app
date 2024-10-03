import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:introduction_screen/introduction_screen.dart';

final List<PageViewModel> pages = [
  PageViewModel(
    title: "",
    bodyWidget: Container(
      child: Column(
        children: [
          SizedBox(height: 80),
          Image.asset(
            'assets/img/onboarding1.png',
            width: 250,
          ),
          SizedBox(
            height: 95,
          ),
          Container(
            width: 200,
            child: Text(
              'Selamat Datang di Menatu',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 275,
            child: Text(
                'Solusi laundry praktis dan terpercaya langsung dari ponselmu.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    ),
    decoration: const PageDecoration(
      pageColor: Colors.white,
    ),
  ),
  PageViewModel(
    title: "",
    bodyWidget: Container(
      child: Column(
        children: [
          SizedBox(height: 80),
          Image.asset(
            'assets/img/onboarding2.png',
            width: 250,
          ),
          SizedBox(
            height: 95,
          ),
          Container(
            width: 200,
            child: Text(
              'Pesan Laundry dalam Sekejap',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 275,
            child: Text(
                'Pilih jenis cucian, tentukan waktu penjemputan, dan atur pengantaran sesuai kebutuhanmu.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    ),
    decoration: const PageDecoration(
      pageColor: Colors.white,
    ),
  ),
  PageViewModel(
    title: "",
    bodyWidget: Container(
      child: Column(
        children: [
          SizedBox(height: 80),
          Image.asset(
            'assets/img/onboarding3.png',
            width: 250,
          ),
          SizedBox(
            height: 95,
          ),
          Container(
            width: 220,
            child: Text(
              'Pantau Pesananmu Secara Real-Time',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 275,
            child: Text(
                'Dapatkan update status cucianmu mulai dari penjemputan hingga pengantaran.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    ),
    decoration: const PageDecoration(
      pageColor: Colors.white,
    ),
  ),
  PageViewModel(
    title: "",
    bodyWidget: Container(
      child: Column(
        children: [
          SizedBox(height: 80),
          Image.asset(
            'assets/img/onboarding4.png',
            width: 250,
          ),
          SizedBox(
            height: 95,
          ),
          Container(
            width: 200,
            child: Text(
              'Siap Memulai?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 275,
            child: Text(
                'Bergabunglah dengan ribuan pengguna lainnya yang telah merasakan kemudahan layanan laundry kami. ',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    ),
    decoration: const PageDecoration(
      pageColor: Colors.white,
    ),
  ),
];
