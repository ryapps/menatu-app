import 'dart:convert';
import 'package:http/http.dart' as http;

class PesananService {
  final String baseUrl =
      'https://menatu.loca.lt/api/pesanan'; // Gantilah dengan URL API Anda

  // Mendapatkan semua pesanan
  Future<List<dynamic>> getPesanan() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(
          response.body); // Mengembalikan data pesanan dalam bentuk list
    } else {
      throw Exception('Gagal mengambil data pesanan');
    }
  }

  // Membuat pesanan baru
  Future<Map<String, dynamic>> createPesanan({
    required int idPelanggan,
    required int idLaundry,
    required String tanggalPesan,
    required int totalHarga,
    required String statusPesanan,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_pelanggan': idPelanggan,
        'id_laundry': idLaundry,
        'tanggal_pesan': tanggalPesan,
        'total_harga': totalHarga,
        'status_pesanan': statusPesanan,
      }),
    );
    print(idPelanggan);
    print(idLaundry);
    print(tanggalPesan);
    print(totalHarga);
    print(statusPesanan);
    if (response.statusCode == 201) {
      return jsonDecode(
          response.body); // Mengembalikan data pesanan yang baru dibuat
    } else {
      print(response.body);
      throw Exception('Gagal membuat pesanan');
    }
  }

  // Mendapatkan pesanan berdasarkan ID
  Future<Map<String, dynamic>> getPesananById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Mengembalikan data pesanan
    } else {
      throw Exception('Pesanan tidak ditemukan');
    }
  }

  // Mengupdate status pesanan
  Future<Map<String, dynamic>> updateStatusPesanan(
      int id, String statusPesanan) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'status_pesanan': statusPesanan,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(
          response.body); // Mengembalikan data pesanan yang telah diperbarui
    } else {
      throw Exception('Gagal memperbarui status pesanan');
    }
  }

  // Menghapus pesanan
  Future<void> deletePesanan(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus pesanan');
    }
  }
}
