class Book {
  final int id;
  final String title;
  final String author;
  int quantity;
  int borrowedBooks;
  final String description;
  final String category;
  final String authorImagePath;
  final String bookImagePath;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.quantity,
    required this.borrowedBooks,
    required this.description,
    required this.category,
    required this.authorImagePath,
    required this.bookImagePath,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: int.parse(json['id'].toString()), // Ensure id is an int
      title: json['title'],
      author: json['author'],
      quantity: int.parse(json['quantity'].toString()), // Ensure quantity is an int
      borrowedBooks: int.parse(json['borrowedBooks'].toString()), // Ensure borrowedBooks is an int
      description: json['description'],
      category: json['category'],
      authorImagePath: json['authorImagePath'],
      bookImagePath: json['bookImagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'title': title,
      'author': author,
      'quantity': quantity.toString(),
      'borrowedBooks': borrowedBooks.toString(),
      'description': description,
      'category': category,
      'authorImagePath': authorImagePath,
      'bookImagePath': bookImagePath,
    };
  }
}