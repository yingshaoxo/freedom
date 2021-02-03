import 'package:flutter/material.dart';
import 'package:path/path.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1),
              child: ElevatedButton(
                child: Text('Export'),
                onPressed: () {
                  // Navigate to second route when tapped.
                },
              ),
            ),
            Container(
              child: ElevatedButton(
                child: Text('Import'),
                onPressed: () {
                  // Navigate to second route when tapped.
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
