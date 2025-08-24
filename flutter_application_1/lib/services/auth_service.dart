import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  // Dynamic base URL detect (Web vs Mobile)
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api'; // Web ?? ????
    } else {
      return 'http://10.0.2.2:8080/api'; // Mobile Emulator ?? ????
    }
  }

  Future<UserModel?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserModel.fromJson(json);
    } else if (response.statusCode == 401) {
      throw Exception('Invalid username or password');
    } else {
      throw Exception('Login failed: ${response.statusCode}');
    }
  }
}
