import 'package:flutter/material.dart';
import 'package:literaland/library-provider.dart';
import 'package:literaland/widget/Book-detail.dart';
import 'package:literaland/widget/image-container.dart';
import 'package:provider/provider.dart';

class MyGridView extends StatelessWidget {
  const MyGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Library>(
      builder: (context, library, child) {
        if (library.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (library.error != null) {
          return Center(child: Text(library.error!, style: TextStyle(color: Colors.white),));
        }

        if (library.books.isEmpty) {
          return Center(child: Text('No books available'));
        }

        return GridView.builder(
          padding: EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: library.books.length,
          itemBuilder: (context, index) {
            final book = library.books[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetailsScreen(bookId: book.id),
                  ),
                );
              },
              child: Hero(
                tag: 'book-${book.id}',
                child: ImageContainer(
                  imagePath: book.imagePath,
                  title: book.title,
                  bookId: book.id,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
