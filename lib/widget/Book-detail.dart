import 'package:flutter/material.dart';
import 'package:literaland/Controller/ApiService.dart';
import 'package:literaland/Controller/NotificationService.dart';
import 'package:literaland/Model/book.dart';

class BookDetailsScreen extends StatefulWidget {
  final int bookId;
  final int userId;

  const BookDetailsScreen({Key? key, required this.bookId, required this.userId}) : super(key: key);

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late Future<Book?> _bookFuture;
  final ApiService _apiService = ApiService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _bookFuture = _apiService.fetchBookById(widget.bookId);
    _initializeNotification();
  }

  Future<void> _initializeNotification() async {
    await _notificationService.initNotification();
  }

  Future<void> _borrowBook(Book book) async {
    try {
      final response = await _apiService.borrowBook(widget.userId, book.id);

      if (response['status'] == 'success') {
        setState(() {
          book.quantity -= 1;
          book.borrowedBooks += 1;
        });
        await _notificationService.showNotification('Buku Berhasil Dipinjam', '${book.title} berhasil ditambahkan ke rak buku Anda');
        
        // Schedule a reminder notification for the book return in 7 days (example)
        DateTime returnReminderDate = DateTime.now().add(Duration(days: 7));
        await _notificationService.scheduleNotification(
          1, 
          'Pengembalian Buku', 
          'Jangan lupa untuk mengembalikan buku ${book.title}.', 
          returnReminderDate,
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to borrow book');
      }
    } catch (e) {
      print('Error borrowing book: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF282b2f),
        centerTitle: true, // Menengahkan teks di AppBar
        iconTheme: IconThemeData(
          color: Colors.white, // Mengubah warna panah kembali menjadi putih
        ),
      ),
      backgroundColor: Color(0xFF282b2f),
      body: FutureBuilder<Book?>(
        future: _bookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Book not found'));
          }

          final book = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 150,
                            height: 225,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(book.bookImagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.all(16),
                            width: 190,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  book.category,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: book.quantity > 0
                                        ? () async {
                                            await _borrowBook(book);
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: book.quantity > 0 ? Color(0xFF7453FC) : Colors.grey,
                                    ),
                                    child: Text(
                                      book.quantity > 0 ? 'Borrow Book' : 'Out of Stock',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          book.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Category: ${book.category}',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Author: ${book.author}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Description:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          book.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Quantity Available: ${book.quantity}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Borrowed Books: ${book.borrowedBooks}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}