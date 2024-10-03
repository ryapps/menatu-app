 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:menatu_app/views/login/otp_verification.dart';

void sendOTP(String phoneNumber, BuildContext context) async {
  
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Verifikasi otomatis sukses
        await _auth.signInWithCredential(credential);
        // Setelah verifikasi otomatis, arahkan pengguna ke reset password
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('Nomor telepon tidak valid.');
        } else {
          print('Verifikasi gagal: ${e.message}');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        // Simpan verificationId dan arahkan ke layar verifikasi OTP
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Waktu habis untuk verifikasi.');
      },
    );
  }
