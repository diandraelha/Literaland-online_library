import 'package:flutter/material.dart';
import 'package:literaland/widget/Book-detail.dart'; // Pastikan ini diimport dengan benar

class ImageContainer extends StatelessWidget {
  final String imagePath;
  final String title;
  final int bookId;

  const ImageContainer({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.bookId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Gunakan Navigator untuk berpindah ke halaman baru
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(bookId: bookId),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(imagePath), // Menggunakan AssetImage untuk gambar lokal
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman baru untuk menampilkan gambar secara penuh
class FullScreenImage extends StatelessWidget {
  final String imagePath;

  const FullScreenImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Sesuaikan warna AppBar
        title: const Text('Full Screen Image'), // Ganti judul AppBar
      ),
      body: Center(
        child: Image.asset( // Menggunakan AssetImage untuk gambar lokal
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
