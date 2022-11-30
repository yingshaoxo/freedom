import 'dart:io';
import 'dart:convert';

// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freedom/data_structures/message.dart';
import 'package:freedom/store/store.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';

class JsonExportAndImportControlelr extends GetxController {
  JsonExportAndImportControlelr() {
    print("json controller initialized");
  }

  Future<void> writeTextDataToFile(File file, String text) async {
    await file.writeAsString(text);
  }

  Future<String> readTextDataFromFile(File file) async {
    return await file.readAsString();
  }

  Future<String> getDatbaseFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path, 'database.json');
  }

  Future<void> saveDatabaseMessageListIntoTheJsonFile() async {
    List<Message> theData = await sqlite_database_controlelr.getMessageList();
    List<Map<String, dynamic>> theList = theData.map((e) => e.toMap()).toList();

    var spaces = ' ' * 4;
    var encoder = JsonEncoder.withIndent(spaces);
    String jsonString = encoder.convert(theList); //jsonEncode(theData);

    String jsonDatabasePath = await getDatbaseFilePath();
    await writeTextDataToFile(File(jsonDatabasePath), jsonString);
  }

  Future<void> exportJsonData() async {
    await saveDatabaseMessageListIntoTheJsonFile();

    String jsonFilePath = await getDatbaseFilePath();
    await Share.shareFiles([jsonFilePath], text: 'Your Ideas Data');
  }

  Future<void> refill_sqlite_database_with_the_content_inside_of_a_json_file(
      {required String newFilePath}) async {
    print("new file path: $newFilePath");

    // do a check to see if the database.json has the old structure or not, if so, convert it to the new one
    String jsonString = await File(newFilePath).readAsString();
    Iterable list = json.decode(jsonString);
    List<Map<String, dynamic>> new_list = [];
    for (Map<String, dynamic> msg in list) {
      if (!msg.containsKey('type')) {
        msg['type'] = 'freedom';
      }
      new_list.add(msg);
    }
    List<Message> new_messages =
        List<Message>.from(new_list.map((mapObj) => Message.fromJson(mapObj)));

    await sqlite_database_controlelr.clean_database();
    await sqlite_database_controlelr.insert_a_list_of_messages(new_messages);

    await sqlite_database_controlelr.sync_messages_data_to_view();
  }
}
