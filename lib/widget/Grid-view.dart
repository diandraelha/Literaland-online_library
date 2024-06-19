import 'package:flutter/material.dart';
import 'package:literaland/Controller/ApiService.dart';
import 'package:literaland/Model/book.dart';
import 'package:literaland/Model/user.dart';
import 'package:literaland/widget/Book-detail.dart';
import 'package:literaland/widget/image-container.dart';

class MyGridView extends StatefulWidget {
  final User user; // Tambahkan user untuk mengirimkan userId

  const MyGridView({Key? key, required this.user}) : super(key: key);

  @override
  _MyGridViewState createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  late Future<List<Book>> _booksFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _booksFuture = _apiService.fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: _booksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No books available', style: TextStyle(color: Colors.white),));
        }

        final books = snapshot.data!;

        return GridView.builder(
          padding: EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetailsScreen(
                      bookId: book.id,
                      userId: widget.user.id, // Kirim userId
                    ),
                  ),
                );
              },
              child: Hero(
                tag: 'book-${book.id}',
                child: ImageContainer(
                  imagePath: book.bookImagePath,
                  title: book.title,
                  bookId: book.id,
                  userId: widget.user.id, // Tambahkan userId untuk ImageContainer
                ),
              ),
            );
          },
        );
      },
    );
  }
}
