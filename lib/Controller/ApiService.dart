import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:literaland/Model/user.dart';
import 'package:literaland/Model/book.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2/api';

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

 
  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/get_books.php'));
    if (response.statusCode == 200) {
      final List<dynamic> bookData = json.decode(response.body);
      return bookData.map((data) => Book.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<Book?> fetchBookById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/get_book_by_id.php?id=$id'));
    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load book');
    }
  }

  Future<Map<String, dynamic>> toggleBookStatus(int id, bool isBorrowed) async {
    final response = await http.post(
      Uri.parse('$baseUrl/toggle_book_status.php'),
      body: {
        'id': id.toString(),
        'isBorrowed': isBorrowed ? '1' : '0',
      },
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> addBook(Book book) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save_book.php'),
      body: {
        'title': book.title,
        'imagePath': book.imagePath,
        'isBorrowed': book.isBorrowed ? '1' : '0',
      },
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> deleteBook(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete_book.php'),
      body: {'id': id.toString()},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateBook(Book book) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update_book.php'),
      body: book.toJson(),
    );
    return jsonDecode(response.body);
  }
}