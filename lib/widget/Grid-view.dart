import 'package:flutter/material.dart';
import 'package:literaland/widget/image-container.dart';

class MyGridView extends StatelessWidget {
  const MyGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: const [
        ImageContainer(
          imagePath: 'assets/images/Arsene-Lupin.jpg',
          title: 'Arsene-Lupin',
        ),
      ],
    );
  }
}
