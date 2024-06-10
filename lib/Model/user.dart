class User {
  final int id;
  final String username;
  final String email;
  String? profilePictureUrl; // Add this field

  User({required this.id, required this.username, required this.email, this.profilePictureUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id'].toString()), // Convert id to int explicitly
      username: json['username'],
      email: json['email'],
      profilePictureUrl: json['profilePictureUrl'], // Add this line
    );
  }
}