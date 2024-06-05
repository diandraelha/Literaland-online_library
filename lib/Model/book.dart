class Book {
  final int id;
  final String title;
  final String imagePath;
  bool isBorrowed;

  Book({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.isBorrowed,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: int.parse(json['id']),
      title: json['title'],
      imagePath: json['imagePath'],
      isBorrowed: json['isBorrowed'] == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'title': title,
      'imagePath': imagePath,
      'isBorrowed': isBorrowed ? '1' : '0',
    };
  }

  void toggleBorrowedStatus() {
    isBorrowed = !isBorrowed;
  }
}
