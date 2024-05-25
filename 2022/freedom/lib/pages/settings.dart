import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freedom/store/store.dart';
import 'package:freedom/tools/disk_tools.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<bool> import_my_json_data_if_it_exists() async {
    File the_json_file = File(await get_my_json_path());
    if (!the_json_file.existsSync()) {
      return false;
    }

    Fluttertoast.showToast(
      msg: "Data in loading, plase have patience.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );
    
    bool result = await json_export_and_import_controller
        .refill_sqlite_database_with_the_content_inside_of_a_json_file(
            newFilePath: the_json_file.path);

    if (result == true) {
      Fluttertoast.showToast(
        msg: "The importing process is done.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );

      await the_json_file.delete();

      return true;
    }

    return false;
  }


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
                    String the_json_path = await get_my_json_path();
                    print(the_json_path);
                    bool result = await import_my_json_data_if_it_exists();
                    print(result);
                    if (result == true) {
                      Navigator.of(context).pop();
                      return;
                    }
                    return showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text('Tips'),
                              content: Text(
                                  'You need to find your "database.json" file in a file manager, \nChange its name to "database.json.jpg", \nThen share it to me.\n\n\nIf it not work, you can move your database.json to path "' + the_json_path + '", then hit the import button again because android system was controlled not by you.'),
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
