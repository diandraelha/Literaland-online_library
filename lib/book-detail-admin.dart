import 'package:flutter/material.dart';
import 'package:literaland/Controller/ApiService.dart';
import 'package:literaland/Model/book.dart';

class BookDetailAdmin extends StatefulWidget {
  final Book book;
  final VoidCallback onUpdate;

  const BookDetailAdmin({Key? key, required this.book, required this.onUpdate}) : super(key: key);

  @override
  _BookDetailAdminState createState() => _BookDetailAdminState();
}

class _BookDetailAdminState extends State<BookDetailAdmin> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _quantityController = TextEditingController(text: widget.book.quantity.toString());
    _descriptionController = TextEditingController(text: widget.book.description);
    _categoryController = TextEditingController(text: widget.book.category);
  }

  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate()) {
      final updatedBook = Book(
        id: widget.book.id,
        title: _titleController.text,
        author: _authorController.text,
        quantity: int.parse(_quantityController.text),
        borrowedBooks: widget.book.borrowedBooks,
        description: _descriptionController.text,
        category: _categoryController.text,
        authorImagePath: widget.book.authorImagePath,
        bookImagePath: widget.book.bookImagePath,
      );

      final response = await _apiService.updateBook(updatedBook);
      if (response['success']) {
        widget.onUpdate();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update book')));
      }
    }
  }

  Future<void> _deleteBook() async {
    try {
      final response = await _apiService.deleteBook(widget.book.id);
      if (response['success']) {
        widget.onUpdate();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete book: ${response['error']}'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete book: ${e.toString()}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteBook,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateBook,
                child: Text('Update Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}