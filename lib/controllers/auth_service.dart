import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // create new account using email password method
  Future createAccountWithEmail(String email, String password, String username) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      
      await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'username': username,
      'email': email,
    });
      return "Akun telah terdaftar";
    } on FirebaseAuthException {
      return 'Maaf, akun sudah terdaftarkan sebelumnya';
    }
    
  }


  // login with email password method
  Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Login berhasil!";
    } on FirebaseAuthException {
      return 'Maaf, Akun tidak ditemukan!';
    }
  }

  // logout the user
  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }


  // for login with google

}
