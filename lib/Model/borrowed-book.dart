class BorrowedBook {
  final int id;
  final int userId;
  final int bookId;
  final DateTime borrowedDate;
  final DateTime dueDate;
  final DateTime? returnedDate;
  final String status;

  BorrowedBook({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.borrowedDate,
    required this.dueDate,
    this.returnedDate,
    required this.status,
  });

  factory BorrowedBook.fromJson(Map<String, dynamic> json) {
    return BorrowedBook(
      id: int.parse(json['id'].toString()),  // Convert id to int
      userId: int.parse(json['user_id'].toString()),  // Convert user_id to int
      bookId: int.parse(json['book_id'].toString()),  // Convert book_id to int
      borrowedDate: DateTime.parse(json['borrowed_date']),
      dueDate: DateTime.parse(json['due_date']),
      returnedDate: json['returned_date'] != null
          ? DateTime.parse(json['returned_date'])
          : null,
      status: json['status'] ?? '',  // Ensure status is not null
    );
  }
}