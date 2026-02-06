import 'dart:convert';
import '../../../core/network/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  // 1. Register
  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await _apiService.post('/register', {
      'email': email,
      'password': password,
    });
    return jsonDecode(response.body);
  }

  // 2. Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiService.post('/login', {
      'email': email,
      'password': password,
    });
    return jsonDecode(response.body);
  }

  // 3. Forgot Password (Request 5 Digit Token)
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await _apiService.post('/forgot-password', {
      'email': email,
    });
    return jsonDecode(response.body);
  }

  // Verify Reset Token
  Future<Map<String, dynamic>> verifyResetToken(String token) async {
    final response = await _apiService.post('/verify-reset-token', {
      'token': token,
    });
    return jsonDecode(response.body);
  }

  // 4. Reset Password
  Future<Map<String, dynamic>> resetPassword(
    String token,
    String newPassword,
  ) async {
    final response = await _apiService.post('/reset-password', {
      'token': token,
      'newPassword': newPassword,
    });
    return jsonDecode(response.body);
  }
}
