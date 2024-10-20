import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:menatu_app/controllers/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class EmailVerificationScreen extends StatefulWidget {
  EmailVerificationScreen({super.key, required this.toEmail});
  final String toEmail;

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  AuthService authService = AuthService();
  Timer? _timer;
  bool _isVerified = false;
  bool _isChecking = true;
  int _start = 60; // Waktu dalam detik
  bool isButtonDisabled = false;
  int? _userId;

  @override
  initState() {
    super.initState();
    _startVerificationCheck();
  }

  @override
  void dispose() {
    // Hentikan timer saat widget dihapus
    _timer?.cancel();
    super.dispose();
  }

  void _startVerificationCheck() async {
    int? userId = await getUserId(); // Ambil userId dari Shared Preferences

    if (userId != null) {
      _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) async {
        await _checkVerification(
            userId); // Panggil fungsi untuk memeriksa verifikasi
      });
    } else {
      setState(() {
        _isChecking = false;
        // Jika userId null, hentikan pengecekan
      });
      print('User ID is null, unable to check verification.');
    }
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Mengambil userId dari SharedPreferences
  }

  Future<void> _checkVerification(id) async {
    try {
      final response = await http.get(
        Uri.parse('https://menatu.serveo.net/api/check-verification/$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _isVerified = data['verified'];
          _isChecking = false;
           _userId = id;
        });

        // Jika sudah terverifikasi, hentikan timer
        if (_isVerified) {
          _timer?.cancel();
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Tangani kesalahan jika perlu
        setState(() {
          _isChecking = false;
        });
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Tangani kesalahan jaringan
      setState(() {
        _isChecking = false;
      });

      print('Error: $e');
    }
  }

  // Fungsi untuk memulai timer hitung mundur
  void startTimer() {
    setState(() {
      isButtonDisabled = true;
      _start = 60; // Set ulang waktu menjadi 60 detik
    });

    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          isButtonDisabled = false; // Aktifkan tombol kembali
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  // Fungsi untuk melakukan resend verification (panggilan API)
  void resendVerification() {
    // Panggil API resend verification di sini
    print("Resend verification email sent!");

    // Mulai timer setelah tombol ditekan
    startTimer();
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: widget.toEmail,
      query: Uri.encodeFull(
          'subject=Verifikasi Email&body=Silakan verifikasi akun Anda'),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 220,
                child: Text(
                  'Verifikasi Email',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 22),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 230,
                child: Text(
                  'Tombol verifikasi telah terkirim ke email anda',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
              ),
              SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/email_verif.png',
                      width: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      textAlign: TextAlign.center,
                      'Kami telah mengirim email ke ${widget.toEmail}. Setelah menerima email, tekan tombol yang disediakan untuk menyelesaikan pendaftaran Anda',
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor)),
                            onPressed: _launchEmail,
                            child: Text(
                              'Buka Gmail',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ))),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Tidak mendapatkan email?",
                          style: TextStyle(fontSize: 12),
                        ),
                        TextButton(
                            onPressed: () async {
                              if (isButtonDisabled) {
                                null;
                              } else {
                                resendVerification();
                                await authService.resendVerification(
                                  widget.toEmail,_userId!
                                );
                              }
                              ;
                            },
                            child: isButtonDisabled
                                ? Text("Tunggu $_start detik")
                                : Text(
                                    'Kirim Ulang',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold),
                                  )),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
