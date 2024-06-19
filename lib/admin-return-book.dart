import 'package:flutter/material.dart';
import 'package:literaland/Controller/ApiService.dart';
import 'package:literaland/Model/book.dart';
import 'package:literaland/Model/borrowed-book.dart';

class AdminReturnBooksScreen extends StatefulWidget {
  @override
  _AdminReturnBooksScreenState createState() => _AdminReturnBooksScreenState();
}

class _AdminReturnBooksScreenState extends State<AdminReturnBooksScreen> {
  late Future<List<BorrowedBook>> _borrowedBooksFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _borrowedBooksFuture = _apiService.fetchAllBorrowedBooks();
  }

  Future<void> _returnBook(BorrowedBook book) async {
    try {
      final response = await _apiService.returnBook(book.userId, book.bookId);
      print('Raw response: $response'); // Add this line to log the raw response

      if (response['status'] == 'success') {
        setState(() {
          _borrowedBooksFuture = _apiService.fetchAllBorrowedBooks();
        });
      } else {
        throw Exception(response['message'] ?? 'Failed to return book');
      }
    } catch (e) {
      print('Error returning book: $e');
    }
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
        title: Text('Return Books'),
      ),
      body: FutureBuilder<List<BorrowedBook>>(
        future: _borrowedBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No borrowed books found'));
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
      shadowColor: Colors.black38,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Hero(
              tag: 'bookImage-${borrowedBook.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  book.bookImagePath,
                  fit: BoxFit.cover,
                  width: 80,
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.broken_image,
                      size: 80,
                      color: Colors.grey,
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Author: ${book.author}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        'Borrowed: ${borrowedBook.borrowedDate.toLocal().toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        'Due: ${borrowedBook.dueDate.toLocal().toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        'Returned: ${borrowedBook.returnedDate?.toLocal().toString().split(' ')[0] ?? 'Not yet returned'}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  borrowedBook.returnedDate == null
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            await _returnBook(borrowedBook);
                          },
                          child: Text('Return Book'),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}