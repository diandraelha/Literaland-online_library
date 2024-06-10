class BorrowedBook {
  final int id;
  final String title;
  final String author;
  final String bookImagePath;
  final DateTime borrowedDate;
  final DateTime dueDate;
  final DateTime? returnedDate;

  BorrowedBook({
    required this.id,
    required this.title,
    required this.author,
    required this.bookImagePath,
    required this.borrowedDate,
    required this.dueDate,
    this.returnedDate,
  });

  factory BorrowedBook.fromJson(Map<String, dynamic> json) {
    return BorrowedBook(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      bookImagePath: json['bookImagePath'],
      borrowedDate: DateTime.parse(json['borrowed_date']),
      dueDate: DateTime.parse(json['due_date']),
      returnedDate: json['returned_date'] != null
          ? DateTime.parse(json['returned_date'])
          : null,
    );
  }
}