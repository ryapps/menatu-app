import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<String?> getUserName() async {
  try {
    // Mendapatkan pengguna yang sedang login
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Ambil data pengguna dari Firestore berdasarkan UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        // Mengambil nama dari data pengguna
        return (userDoc.data() as Map<String, dynamic>)['username'];
      } else {
        print("Data pengguna tidak ditemukan.");
      }
    }
  } catch (e) {
    print("Error saat mengambil data pengguna: $e");
  }
  return null; // Jika tidak ada pengguna yang login atau ada kesalahan
}