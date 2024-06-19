import 'package:flutter/material.dart';
import 'package:literaland/Controller/ApiService.dart';
import 'package:literaland/Model/book.dart';
import 'package:literaland/admin-add-book-form.dart';
import 'package:literaland/book-detail-admin.dart';


class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<List<Book>> _booksFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  void _fetchBooks() {
    setState(() {
      _booksFuture = _apiService.fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282b2f),
      appBar: AppBar(
        title: Text('Dashboard Admin'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No books available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final books = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                title: Text(book.title, style: TextStyle(color: Colors.white)),
                subtitle: Text(book.author, style: TextStyle(color: Colors.white70)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailAdmin(book: book, onUpdate: _fetchBooks),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookForm(onSubmit: _fetchBooks)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
