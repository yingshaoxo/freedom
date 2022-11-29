import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive/hive.dart';

import 'package:freedom/data_structures/message.dart';
import 'package:freedom/store/store.dart';
import 'package:freedom/tools/disk_tools.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabaseControlelr extends GetxController {
  SqliteDatabaseControlelr() {
    print("sqlite database controller initialized");
  }

  var box;
  bool onlyShowTodayInHistory = false;

  late Database database_handler;
  String message_table_string = "message_table";
  String image_table_string = "image_table";

  Future<void> initializeSettings() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    await Hive.openBox("myBox");
    box = Hive.box('myBox');
    onlyShowTodayInHistory =
        box.get("onlyShowTodayInHistory", defaultValue: false);
  }

  Future<void> initializeDatabase() async {
    String database_folder_path = await getDatabasesPath();
    String sqlite_database_file_path =
        path_join(path1: database_folder_path, path2: "database.db");

    database_handler = await openDatabase(
      sqlite_database_file_path,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE ${message_table_string}(type TEXT, date TEXT, content TEXT, images TEXT)",
        );
        await db.execute(
          "CREATE TABLE ${image_table_string}(hash_id TEXT, base64_image_string TEXT)",
        );
      },
      version: 1,
    );

    sync_messages_data_to_view();
  }

  Future<void> insertMessage(Message msg) async {
    await database_handler.insert(
      message_table_string,
      msg.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMessage(Message msg) async {
    await database_handler.update(message_table_string, msg.toMap(),
        where: 'type = ? AND date = ?', whereArgs: [msg.type, msg.date]);
  }

  Future<void> deleteMessage(Message msg) async {
    String images = Message.convertListOfStringToString(msg.images);

    await database_handler.delete(message_table_string,
        where: 'type = ? AND date = ? AND content = ? AND images = ?',
        whereArgs: [msg.type, msg.date, msg.content, images]);
  }

  Future<void> clean_database() async {
    await database_handler.execute("DELETE FROM ${message_table_string};");
    await database_handler.execute("DELETE FROM ${image_table_string};");
  }

  Future<List<Message>> searchMessages({required String text}) async {
    List<String> keywords = text.split(" ");

    String whereString =
        keywords.map((e) => "content LIKE ?").toList().join(" AND ");
    List<String> whereArgs = keywords.map((e) => "%$e%").toList();

    final List<Map<String, dynamic>> maps = await database_handler
        .query(message_table_string, where: whereString, whereArgs: whereArgs);

    return maps.map((e) => Message.fromJson(e)).toList();
  }

  Future<List<Message>> getMessageList() async {
    final List<Map<String, dynamic>> maps =
        await database_handler.query(message_table_string);

    return maps.map((e) => Message.fromJson(e)).toList();
  }

  // Message getAFakeMessage() {
  //   return Message(
  //       type: "freedom", date: "1.1", content: "I love you.", images: []);
  //   //new Message(date: "2.1", content: "I don't love you anymore.")
  // }

  Future<void> sync_messages_data_to_view() async {
    var message_list = await getMessageList();
    await memory_database_controller.syncMessageList(
        newMessageList: message_list);
  }
}

String getBase64StringFromUint8List(Uint8List data) {
  return base64Encode(data);
}

Uint8List getUint8ListFromBase64String(String base64String) {
  return base64Decode(base64String);
}

Future<Uint8List> uint8ListImageCompress(Uint8List list) async {
  if (list.lengthInBytes > 300000) {
    // if the image size > 300KB, we compress
    var result = await FlutterImageCompress.compressWithList(list,
        minHeight: 1920, minWidth: 1080, quality: 50);
    return result;
  } else {
    return list;
  }
}

Image getImageFromBase64String(String base64String) {
  return Image.memory(getUint8ListFromBase64String(base64String));
}
