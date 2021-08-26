import 'package:flutter/material.dart';
import 'package:freedom/store/store.dart';

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
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green)),
                child: Text('Export (json)'),
                onPressed: () async {
                  await databaseController.exportJsonData();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1),
              child: ElevatedButton(
                child: Text('Export'),
                onPressed: () async {
                  await databaseController.exportDatabase();
                },
              ),
            ),
            Container(
              child: ElevatedButton(
                child: Text('Import'),
                onPressed: () async {
                  return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text('Tips'),
                            content: Text(
                                'You need to find your database.db file in a file manager APP, \n\nthen share it to me.'),
                            actions: <Widget>[
                              TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })
                            ]);
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
