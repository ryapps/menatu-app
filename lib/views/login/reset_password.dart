import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password Baru'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Ubah password pengguna
                  User? user = FirebaseAuth.instance.currentUser;
                  await user?.updatePassword(_passwordController.text);
                  print("Password berhasil diperbarui");
                  // Setelah berhasil, kembali ke halaman login
                  Navigator.pop(context);
                } catch (e) {
                  print("Error: $e");
                }
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
