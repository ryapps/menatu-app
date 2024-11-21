import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:menatu_app/models/Laundry.dart';

final String baseUrl = 'https://menatu.loca.lt/api';

class LaundryService {
  Future<List<Laundry>> fetchNearbyLaundries(
      double latitude, double longitude) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/laundries-nearby?latitude=$latitude&longitude=$longitude'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse.map((laundry) => Laundry.fromJson(laundry)).toList();
    } else {
      throw Exception('Failed to load nearby laundries');
    }
  }

  Future<void> updateLaundryStatus(int id) async {
    final url = Uri.parse('$baseUrl/laundries/$id/status');
    final response = await http.put(url);

    if (response.statusCode == 200) {
      print('Status updated successfully');
    } else {
      throw Exception('Failed to update status');
    }
  }

  Future<Laundry> getLaundryById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/laundries/$id'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Laundry.fromJson(json['data']);
    } else {
      throw Exception('Failed to load laundry');
    }
  }
}
