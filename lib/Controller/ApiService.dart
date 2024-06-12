import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:literaland/Model/book.dart';
import 'package:literaland/Model/borrowed-book-history.dart';
import 'package:literaland/Model/borrowed-book.dart';
import 'package:literaland/Model/user.dart';

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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'success' && data['user'] != null) {
        User user = User.fromJson(data['user']);
        return {'status': 'success', 'user': user};
      } else {
        return {'status': 'error', 'message': data['message'] ?? 'User data is missing'};
      }
    } else {
      return {'status': 'error', 'message': 'Failed to login'};
    }
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

  Future<Map<String, dynamic>> toggleBookStatus(int id, int borrowedBooks) async {
    final response = await http.post(
      Uri.parse('$baseUrl/toggle_book_status.php'),
      body: {
        'id': id.toString(),
        'borrowed': borrowedBooks.toString(),
      },
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> addBook(Book book) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save_book.php'),
      body: book.toJson(),
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

  Future<Map<String, dynamic>> borrowBook(int userId, int bookId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/borrow_book.php'),
      body: {
        'user_id': userId.toString(),
        'book_id': bookId.toString(),
      },
    );
    return jsonDecode(response.body);
  }

   Future<Map<String, dynamic>> returnBook(int userId, int bookId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/return_book.php'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId.toString(),
        'book_id': bookId.toString(),
      }),
    );

    print('Raw response: ${response.body}'); // Add this line to log the raw response
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to return book');
    }
  }

  Future<List<BorrowedBook>> fetchBorrowedBooks(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/get_borrowed_books.php?user_id=$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> bookData = json.decode(response.body);
      return bookData.map((data) => BorrowedBook.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load borrowed books');
    }
  }

  Future<List<BorrowedBookHistory>> fetchBorrowedBooksHistory(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/get_borrowed_books_history.php?user_id=$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> bookData = json.decode(response.body);
      return bookData.map((data) => BorrowedBookHistory.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load borrowed books history');
    }
  }

  Future<void> updateBorrowedBookStatus(int userId, int bookId, String returnedDate, String status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update_borrowed_book_status.php'),
      body: {
        'user_id': userId.toString(),
        'book_id': bookId.toString(),
        'returned_date': returnedDate,
        'status': status,
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['message'] != 'Update successful') {
        throw Exception('Failed to update borrowed book status');
      }
    } else {
      throw Exception('Failed to update borrowed book status');
    }
  }

  Future<Book> fetchBookDetails(int bookId) async {
    final response = await http.get(Uri.parse('$baseUrl/books/$bookId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Book.fromJson(data);
    } else {
      throw Exception('Failed to load book details');
    }
  }

  Future<void> updateUserProfilePicture(int userId, String profileImageUrl) async {
    final postData = {'userId': userId.toString(), 'profilePictureUrl': profileImageUrl};
    print('Sending POST data: $postData'); // Log the POST data

    final response = await http.post(
      Uri.parse('$baseUrl/update_user_picture_url.php'),
      body: postData,
      headers: {"Content-Type": "application/x-www-form-urlencoded"}, // Explicitly set content type
    );

    final responseBody = response.body;
    print('Raw response: $responseBody'); // Log the raw response

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(responseBody);
      if (jsonResponse['success']) {
        print('Profile picture updated successfully');
      } else {
        throw Exception('Failed to update profile picture: ${jsonResponse['error']}');
      }
    } else {
      throw Exception('Failed to update profile picture');
    }
  }

  Future<List<BorrowedBook>> fetchAllBorrowRequests() async {
    final response = await http.get(Uri.parse('$baseUrl/get_all_borrow_request.php'));
    if (response.statusCode == 200) {
      final List<dynamic> bookData = json.decode(response.body);
      return bookData.map((data) => BorrowedBook.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load borrow requests');
    }
  }

  // Metode baru untuk mengambil semua buku yang dipinjam
  Future<List<BorrowedBook>> fetchAllBorrowedBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/get_all_borrowed_books.php'));
    if (response.statusCode == 200) {
      final List<dynamic> bookData = json.decode(response.body);
      return bookData.map((data) => BorrowedBook.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load borrowed books');
    }
  }

  Future<Map<String, dynamic>> updateBorrowStatus(int borrowId, String status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update_borrow_status.php'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'borrow_id': borrowId.toString(),
        'status': status,
      }),
    );

    print('Raw response: ${response.body}'); // Log the raw response

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update borrow status');
    }
  }
}