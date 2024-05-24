import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:literaland/Model/user.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2/api'; // Ganti dengan IP Anda

  Future<Map<String, dynamic>> register(String username, String password, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      body: {'username': username, 'password': password, 'email': email},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      body: {'username': username, 'password': password},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateProfile(User user, String? newPassword) async {
    final body = {
      'user_id': user.id.toString(),
      'username': user.username,
      'email': user.email,
    };
    if (newPassword != null) {
      body['password'] = newPassword;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/update.php'),
      body: body,
    );
    return jsonDecode(response.body);
  }
}