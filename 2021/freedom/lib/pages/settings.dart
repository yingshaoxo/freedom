import 'package:flutter/material.dart';
import 'package:freedom/store/store.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
                child: Text('Export'),
                onPressed: () async {
                  await databaseController.exportJsonData();
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
                                'You need to find your database.json file in a file manager APP, \n\nthen share it to me.'),
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
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.all<Color>(Colors.green),
                  value: databaseController.onlyShowTodayInHistory,
                  onChanged: (bool? value) {
                    if (value != null) {
                      databaseController.onlyShowTodayInHistory = value;
                      databaseController.box
                          .put("onlyShowTodayInHistory", value);
                      setState(() {});
                    }
                  },
                ),
                Text("Only show today over years")
              ],
            )
          ],
        ),
      ),
    );
  }
}
