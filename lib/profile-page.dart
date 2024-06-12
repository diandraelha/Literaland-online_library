import 'dart:io';
import 'package:flutter/material.dart';
import 'package:literaland/Model/borrowed-book-history.dart';
import 'package:literaland/Model/book.dart';
import 'package:literaland/Model/user.dart';
import 'package:literaland/Controller/ApiService.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<BorrowedBookHistory>> _borrowedBooksHistoryFuture;
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _borrowedBooksHistoryFuture = _apiService.fetchBorrowedBooksHistory(widget.user.id);
    _checkProfilePicture();
  }

  Future<Book?> _fetchBook(int bookId) async {
    try {
      final book = await _apiService.fetchBookById(bookId);
      return book;
    } catch (e) {
      return null;
    }
  }

  Future<void> _checkProfilePicture() async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${widget.user.id}.jpg');
      String downloadUrl = await storageReference.getDownloadURL();
      setState(() {
        widget.user.profilePictureUrl = downloadUrl;
      });
    } catch (e) {
      // If the image does not exist, we catch the error and do nothing,
      // the default image will be shown instead.
      print('No profile picture found, using default.');
    }
  }

  Future<void> _pickImage() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        content: Text('Choose the source for the profile picture'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImageFromSource(ImageSource.camera);
            },
            child: Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImageFromSource(ImageSource.gallery);
            },
            child: Text('Gallery'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      try {
        String downloadUrl = await _uploadImageToFirebase(image);
        await _updateUserProfilePicture(downloadUrl);
        setState(() {
          widget.user.profilePictureUrl = downloadUrl;
        });
      } catch (e) {
        // Handle error
        print('Error updating profile picture: $e');
      }
    }
  }

  Future<String> _uploadImageToFirebase(XFile image) async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${widget.user.id}.jpg');
      UploadTask uploadTask = storageReference.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error during upload: $e');
      throw e;
    }
  }

  Future<void> _updateUserProfilePicture(String downloadUrl) async {
    try {
      await _apiService.updateUserProfilePicture(widget.user.id, downloadUrl);
    } catch (e) {
      print('Error updating profile picture in database: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Page', 
          style: TextStyle(
            color: Colors.white
          )
        ),
        backgroundColor: Color(0xFF7453FC),
        centerTitle: true, // Menengahkan teks di AppBar
        iconTheme: IconThemeData(
          color: Colors.white, // Mengubah warna panah kembali menjadi putih
        ),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF22252A),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: widget.user.profilePictureUrl != null
                        ? NetworkImage(widget.user.profilePictureUrl!)
                        : AssetImage('lib/assets/images/The-Shadow-of-Blackhole.jpg') as ImageProvider,
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.username,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.user.email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Divider(),
          Expanded(
            child: FutureBuilder<List<BorrowedBookHistory>>(
              future: _borrowedBooksHistoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load borrowed books history'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No borrowed books history found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final bookHistory = snapshot.data![index];
                      return FutureBuilder<Book?>(
                        future: _fetchBook(bookHistory.bookId),
                        builder: (context, bookSnapshot) {
                          if (bookSnapshot.connectionState == ConnectionState.waiting) {
                            return _buildLoadingCard();
                          } else if (bookSnapshot.hasError || !bookSnapshot.hasData) {
                            return _buildErrorCard();
                          } else {
                            final book = bookSnapshot.data!;
                            return _buildBookCard(bookHistory, book);
                          }
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Loading book details...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 16),
            Text('Error loading book details'),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(BorrowedBookHistory bookHistory, Book book) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      color: Color(0xFF282b2f),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                      SizedBox(width: 4),
                      Text(
                        'Borrowed: ${bookHistory.borrowedDate}', 
                        style: TextStyle(
                          color: Colors.white60
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                      SizedBox(width: 4),
                      Text(
                        'Due: ${bookHistory.dueDate}', 
                        style: TextStyle(
                          color: Colors.white60
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                      SizedBox(width: 4),
                      Text(
                        'Returned: ${bookHistory.returnedDate ?? "Not yet returned"}',
                        style: TextStyle(
                          color: Colors.white60
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _buildStatusChip(bookHistory.status),
                ],
              ),
            ),
            SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                book.bookImagePath, // Assuming 'bookImagePath' is a property of the 'Book' model
                height: 100,
                width: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.broken_image,
                    size: 70,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'rejected':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red;
        break;
      case 'returned_late':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange;
        break;
      case 'returned_on_time':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green;
        break;
      default:
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[700]!;
    }

    return Chip(
      label: Text(
        status,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
      backgroundColor: backgroundColor,
    );
  }
}