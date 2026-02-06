import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_config.dart';

class ApiService {
  // Base Headers
  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // POST Request
  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse("${AppConfig.baseUrl}$endpoint");
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      // Menangani error koneksi (misal: Firewall aktif atau IP salah)
      throw Exception("Koneksi gagal: $e");
    }
  }
}
