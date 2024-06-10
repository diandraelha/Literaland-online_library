class BorrowedBookHistory {
  final int bookId;
  final String title;
  final String author;
  final String bookImagePath;
  final DateTime borrowedDate;
  final DateTime dueDate;
  final DateTime? returnedDate;
  final String status;

  BorrowedBookHistory({
    required this.bookId,
    required this.title,
    required this.author,
    required this.bookImagePath,
    required this.borrowedDate,
    required this.dueDate,
    this.returnedDate,
    required this.status,
  });

  factory BorrowedBookHistory.fromJson(Map<String, dynamic> json) {
    return BorrowedBookHistory(
      bookId: json['book_id'],
      title: json['title'],
      author: json['author'],
      bookImagePath: json['bookImagePath'],
      borrowedDate: DateTime.parse(json['borrowed_date']),
      dueDate: DateTime.parse(json['due_date']),
      returnedDate: json['returned_date'] != null ? DateTime.parse(json['returned_date']) : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'title': title,
      'author': author,
      'bookImagePath': bookImagePath,
      'borrowed_date': borrowedDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'returned_date': returnedDate?.toIso8601String(),
      'status': status,
    };
  }
}