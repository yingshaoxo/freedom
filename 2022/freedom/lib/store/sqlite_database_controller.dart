import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive/hive.dart';

import 'package:freedom/data_structures/message.dart';
import 'package:freedom/store/store.dart';
import 'package:freedom/tools/disk_tools.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabaseControlelr extends GetxController {
  SqliteDatabaseControlelr() {
    print("sqlite database controller initialized");
  }

  var box;
  bool onlyShowTodayInHistory = false;

  var databaseFactory = databaseFactoryFfi;

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
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
    }

    String database_folder_path = await getDatabasesPath();
    String sqlite_database_file_path =
        path_join(path1: database_folder_path, path2: "database.db");

    database_handler =
        await databaseFactory.openDatabase(sqlite_database_file_path,
            options: OpenDatabaseOptions(
              version: 1,
              onCreate: (db, version) async {
                await db.execute(
                  "CREATE TABLE ${message_table_string}(type TEXT, date TEXT, content TEXT, images TEXT)",
                );
                await db.execute(
                  "CREATE TABLE ${image_table_string}(hash_id TEXT, base64_image_string TEXT)",
                );
              },
            ));

    await memory_database_controller.show_default_message_list();
  }

  Future<void> insertMessage(Message msg) async {
    await database_handler.insert(
      message_table_string,
      msg.toSqliteMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insert_a_list_of_messages(List<Message> msg_list) async {
    var batch = database_handler.batch();
    for (Message msg in msg_list) {
      batch.insert(
        message_table_string,
        msg.toSqliteMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<void> updateMessage(Message msg) async {
    await database_handler.update(message_table_string, msg.toSqliteMap(),
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

  Future<Message?> search_message_by_type_and_date(
      {required Message msg}) async {
    final List<Map<String, dynamic>> maps = await database_handler.query(
        message_table_string,
        where: 'type = ? AND date = ?',
        whereArgs: [msg.type, msg.date]);
    final msg_list = maps.map((e) => Message.fromJson(e)).toList();
    if (msg_list.isEmpty) {
      return null;
    } else {
      return msg_list[0];
    }
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

  Future<List<Message>> search_messages_that_sent_on_the_same_day_of_the_years(
      {required bool go_back_to_past_order}) async {
    DateTime now = new DateTime.now();
    String month_and_day = (new DateFormat('MM-dd')).format(now);
    //2020-02-24 00:00:00 -> 02-24
    final date_filter = "%%%%-${month_and_day} %";

    final List<Map<String, dynamic>> maps = await database_handler.query(
        message_table_string,
        where: "date LIKE ?",
        whereArgs: [date_filter]);

    final result_list = maps.map((e) => Message.fromJson(e)).toList();
    if (go_back_to_past_order) {
      return result_list.reversed.toList();
    } else {
      return result_list;
    }
  }

  Future<List<Message>> get_message_list_by_page_number_and_page_size(
      {required int page_number,
      required int page_size,
      required bool go_back_to_past_order}) async {
    var raw_result = await database_handler.rawQuery(
        "SELECT * FROM ${message_table_string} ORDER BY date ${go_back_to_past_order ? 'DESC' : 'ASC'} LIMIT ${page_size} OFFSET ${page_number * page_size}");
    var message_list = raw_result.map((e) => Message.fromJson(e)).toList();
    return message_list;
  }

  Future<List<Message>> get_message_list_by_offset_and_limit(
      {required int offset,
      required int limit,
      required bool go_back_to_past_order}) async {
    var raw_result = await database_handler.rawQuery(
        "SELECT * FROM ${message_table_string} ORDER BY date ${go_back_to_past_order ? 'DESC' : 'ASC'} LIMIT ${limit} OFFSET ${offset}");
    var message_list = raw_result.map((e) => Message.fromJson(e)).toList();
    return message_list;
  }

  Future<List<Message>> getMessageList() async {
    final List<Map<String, dynamic>> maps =
        await database_handler.query(message_table_string);

    return maps.map((e) => Message.fromJson(e)).toList();
  }

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
