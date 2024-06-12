import 'package:flutter/material.dart';
import 'package:literaland/Controller/ApiService.dart';
import 'package:literaland/Model/book.dart';
import 'package:literaland/Model/borrowed-book.dart';
import 'package:literaland/Model/user.dart';

class BorrowedBooksScreen extends StatefulWidget {
  final User user;

  const BorrowedBooksScreen({Key? key, required this.user}) : super(key: key);

  @override
  _BorrowedBooksScreenState createState() => _BorrowedBooksScreenState();
}

class _BorrowedBooksScreenState extends State<BorrowedBooksScreen> {
  late Future<List<BorrowedBook>> _borrowedBooksFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch borrowed books for the user
    _borrowedBooksFuture = _apiService.fetchBorrowedBooks(widget.user.id);
  }

  Future<Book?> _fetchBookDetails(int bookId) async {
    try {
      return await _apiService.fetchBookById(bookId);
    } catch (e) {
      print('Error fetching book details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Borrowed Books', 
          style: TextStyle(
            color: Colors.white,
          )
        ),
        backgroundColor: Color(0xFF7453FC),
        centerTitle: true, // Menengahkan teks di AppBar
        iconTheme: IconThemeData(
          color: Colors.white, // Mengubah warna panah kembali menjadi putih
        ),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF22252A),
      body: FutureBuilder<List<BorrowedBook>>(
        future: _borrowedBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red, fontSize: 16)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No borrowed books', style: TextStyle(color: Colors.grey, fontSize: 16)),
            );
          }

          final borrowedBooks = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: borrowedBooks.length,
            itemBuilder: (context, index) {
              final borrowedBook = borrowedBooks[index];
              return FutureBuilder<Book?>(
                future: _fetchBookDetails(borrowedBook.bookId),
                builder: (context, bookSnapshot) {
                  if (bookSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (bookSnapshot.hasError) {
                    return Center(child: Text('Error fetching book details'));
                  } else if (!bookSnapshot.hasData) {
                    return Center(child: Text('Book details not found'));
                  }

                  final book = bookSnapshot.data!;
                  return _buildBookCard(borrowedBook, book);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBookCard(BorrowedBook borrowedBook, Book book) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      color: Color(0xFF282b2f),
      shadowColor: Colors.black38,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Hero(
              tag: 'bookImage-${borrowedBook.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(book.bookImagePath, fit: BoxFit.cover, width: 80, height: 120),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: TextStyle(
                      fontSize: 18, 
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Author: ${book.author}',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                      SizedBox(width: 5),
                      Text(
                        'Borrowed: ${borrowedBook.borrowedDate}',
                        style: TextStyle(fontSize: 12, color: Colors.white60),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                      SizedBox(width: 5),
                      Text(
                        'Due: ${borrowedBook.dueDate}',
                        style: TextStyle(fontSize: 12, color: Colors.white60),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                      SizedBox(width: 5),
                      Text(
                        'Returned: ${borrowedBook.returnedDate?.toLocal().toString().split(' ')[0] ?? 'Not yet returned'}',
                        style: TextStyle(fontSize: 12, color: Colors.white60),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                      SizedBox(width: 5),
                      Text(
                        'Status: ${borrowedBook.status}',
                        style: TextStyle(fontSize: 12, color: Colors.white60),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}