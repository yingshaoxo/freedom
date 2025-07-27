import 'package:flutter/material.dart';

class FullScreenImagePage extends StatefulWidget {
  final Image image;
  FullScreenImagePage({Key? key, required this.image}) : super(key: key);

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Preview',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: Center(
        child: Container(color: Colors.grey.withAlpha(30), child: widget.image),
      ),
    );
  }
}
