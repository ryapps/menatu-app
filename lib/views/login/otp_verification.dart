import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:menatu_app/views/login/reset_password.dart';

class OTPVerificationScreen extends StatelessWidget {
  final String verificationId;
  final TextEditingController _otpController = TextEditingController();

  OTPVerificationScreen({required this.verificationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verifikasi OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: 'Masukkan OTP'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Verifikasi OTP
                verifyOTP(_otpController.text, context);
              },
              child: Text('Verifikasi'),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk verifikasi OTP
  void verifyOTP(String otpCode, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );

      // Verifikasi OTP dan login pengguna
      await _auth.signInWithCredential(credential);

      // Jika berhasil, arahkan pengguna ke halaman reset password
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
      );
    } catch (e) {
      print('Verifikasi gagal: ${e.toString()}');
    }
  }
}
