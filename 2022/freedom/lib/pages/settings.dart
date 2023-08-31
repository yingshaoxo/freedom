import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        child: SingleChildScrollView(
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
                    EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;
                    EasyLoading.show(status: 'processing...');

                    await json_export_and_import_controller.exportJsonData();

                    EasyLoading.dismiss();
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
                                  'You need to find your "database.json" file in a file manager, \n\nChange its name to "database.json.jpg", \n\nThen share it to me.'),
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
                    value: sqlite_database_controlelr.onlyShowTodayInHistory,
                    onChanged: (bool? value) async {
                      if (value != null) {
                        sqlite_database_controlelr.box
                            .put("onlyShowTodayInHistory", value);
                        sqlite_database_controlelr.onlyShowTodayInHistory =
                            value;
                        await memory_database_controller
                            .show_default_message_list();
                        setState(() {});
                      }
                    },
                  ),
                  SizedBox(
                    width: 0.5.sw,
                    child: AutoSizeText(
                      "Only show today over years",
                      style: TextStyle(fontSize: 15),
                      maxLines: 1,
                      minFontSize: 3,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        value: sqlite_database_controlelr
                            .only_export_freedom_message,
                        onChanged: (bool? value) async {
                          if (value != null) {
                            sqlite_database_controlelr.box
                                .put("only_export_freedom_message", value);
                            sqlite_database_controlelr
                                .only_export_freedom_message = value;
                            setState(() {});
                          }
                        },
                      ),
                      SizedBox(
                        width: 0.5.sw,
                        child: AutoSizeText(
                          "Only export freedom message",
                          style: TextStyle(fontSize: 15),
                          maxLines: 1,
                          minFontSize: 3,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
