import 'package:flutter/material.dart';
import 'package:literaland/widget/Book-detail.dart';

class ImageContainer extends StatelessWidget {
  final String imagePath;
  final String title;
  final int bookId;
  final int userId; // Tambahkan userId

  const ImageContainer({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.bookId,
    required this.userId, // Tambahkan userId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Use Navigator to move to the new page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(
              bookId: bookId,
              userId: userId, // Kirim userId
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(imagePath), // Use AssetImage for local images
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
