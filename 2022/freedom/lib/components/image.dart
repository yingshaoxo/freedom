import 'package:flutter/material.dart';
import 'package:freedom/pages/full_screen_image.dart';

class MyImage extends StatelessWidget {
  final Image image;
  const MyImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FullScreenImagePage(image: image)),
        );
      },
      child: Container(color: Colors.grey.withAlpha(30), child: image),
    );
  }
}
