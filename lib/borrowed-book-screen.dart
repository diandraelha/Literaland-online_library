import 'package:flutter/material.dart';
import 'package:literaland/Controller/ApiService.dart';
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
    _borrowedBooksFuture = _apiService.fetchBorrowedBooks(widget.user.id);
  }

  Future<void> _returnBook(BorrowedBook book) async {
    try {
      final response = await _apiService.returnBook(widget.user.id, book.id);

      if (response['status'] == 'success') {
        setState(() {
          _borrowedBooksFuture = _apiService.fetchBorrowedBooks(widget.user.id);
        });
      } else {
        throw Exception(response['message'] ?? 'Failed to return book');
      }
    } catch (e) {
      print('Error returning book: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrowed Books', style: TextStyle(color: Colors.white)),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
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

          final books = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return _buildBookCard(book);
            },
          );
        },
      ),
    );
  }

  Widget _buildBookCard(BorrowedBook book) {
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
              tag: 'bookImage-${book.id}',
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
                      Text('Borrowed: ${book.borrowedDate}', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 5),
                      Text('Due: ${book.dueDate}', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 5),
                      Text('Returned: ${book.returnedDate ?? "Not yet returned"}', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                    ],
                  ),
                  SizedBox(height: 10),
                  book.returnedDate == null
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            await _returnBook(book);
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