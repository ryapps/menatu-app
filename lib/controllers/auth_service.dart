import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String? _message;
  int? userId;
  bool isVerified = false;
  Map<String, dynamic>? _user;
  final String baseUrl =
      'https://menatu.serveo.net/api'; // Ubah sesuai dengan base URL API Anda

  // Fungsi register user baru
  Future<void> register(String username, String email, String password,
      String confirmPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': username,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      }),
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (response.statusCode == 201) {
      try {
        final data = json.decode(response.body);
        print(data);
        userId = data['id'];
        await prefs.setInt('userId', userId!);
        _message = 'Mengirim pesan ke gmail $email';
        await prefs.setString('message', _message!);
        print(_message);
        // Memanggil setter userId
      } catch (e) {
        _message = 'Terjadi kesalahan saat mengambil data user.';
        print(_message);
      }
    } else {
      if (response.statusCode == 422) {
        _message = 'Email telah terpakai';
        print(_message);
        await prefs.setString('message', _message!);
      } else {
        _message = 'Pendaftaran Gagal';
        print(_message);
      }
    }
  }

  // Fungsi login user
  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Cek apakah token tidak null sebelum menyimpannya
        if (data['access_token'] != null && data['access_token'] is String) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['access_token']);
          return 'Login berhasil!';
        } else {
          return 'Token tidak ditemukan atau tidak valid di respons.';
        }
      } else {
        return 'Login gagal dengan status: ${response.statusCode}';
      }
    } catch (e) {
      print('Error during login: $e');
      return 'Terjadi kesalahan: $e';
    }
  }

  Future<String?> resendVerification(String email, int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/email/resend-verification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Email verifikasi berhasil dikirim ulang!';
      } else {
        return 'Gagal mengirim ulang email verifikasi. Status code: ${response.statusCode}';
      }
    } catch (e) {
      return 'Terjadi kesalahan saat mengirim ulang verifikasi: $e';
    }
  }

  // Fungsi logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Hapus token dari SharedPreferences
      await prefs.remove('token');
    } else {
      throw Exception('Failed to logout');
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null;
  }

  Future<void> getUserById(int userId) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/users/$userId'), // Ganti dengan endpoint API yang sesuai
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Jika request berhasil
      try {
        final data = json.decode(response.body);
        _user = data['data']; // Menyimpan data user berdasarkan ID
        print('User Data: $_user');
        
      } catch (e) {
        print('Error parsing user data: $e');
      }
    } else {
      // Jika request gagal
      print('Failed to get user: ${response.statusCode}');
    }
  }

  // Getter untuk mendapatkan ID pengguna
}
