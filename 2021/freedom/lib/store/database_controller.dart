import 'dart:io';

import 'package:freedom/tools/time_tools.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:share/share.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive/hive.dart';

class DatabaseControlelr extends GetxController {
  DatabaseControlelr() {
    print("database Controller initialized");
  }

  var box;
  bool onlyShowTodayInHistory = false;

  // late Database database;
  List<Message> realMessageList = [];
  RxList<Message> messageList = RxList([]);

  Future<void> initializeDatabase() async {
    String jsonDatabasePath = await getDatbaseFilePath();

    bool fileExists = await File(jsonDatabasePath).exists();

    if (fileExists == false) {
      List aList = [];
      String jsonString = jsonEncode(aList);
      await writeTextDataToFile(File(jsonDatabasePath), jsonString);
    } else {
      String jsonString = await File(jsonDatabasePath).readAsString();
      Iterable list = json.decode(jsonString);
      List<Message> messages =
          List<Message>.from(list.map((mapObj) => Message.fromJson(mapObj)));
      realMessageList.clear();
      realMessageList.addAll(messages);
    }

    // database = await openDatabase(
    //   onCreate: (db, version) {
    //     return db.execute(
    //       "CREATE TABLE messages(date TEXT, content TEXT, images TEXT)",
    //     );
    //   },
    //   version: 1,
    // );

    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    await Hive.openBox("myBox");
    box = Hive.box('myBox');
    onlyShowTodayInHistory =
        box.get("onlyShowTodayInHistory", defaultValue: false);

    await syncMessageList();
  }

  Future<void> writeTextDataToFile(File file, String text) async {
    await file.writeAsString(text);
  }

  Future<String> readTextDataFromFile(File file) async {
    return await file.readAsString();
  }

  Future<void> saveMemoryMessageListIntoTheJsonFile() async {
    List<Map> theData = [];
    for (var value in realMessageList) {
      theData.add(value.toMap());
    }

    var spaces = ' ' * 4;
    var encoder = JsonEncoder.withIndent(spaces);
    String jsonString = encoder.convert(theData); //jsonEncode(theData);

    String jsonDatabasePath = await getDatbaseFilePath();
    await writeTextDataToFile(File(jsonDatabasePath), jsonString);
  }

  Future<String> getDatbaseFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path, 'database.json');
  }

  // Future<String> getJsonFilePath() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return join(directory.path, 'data.json');
  // }

  Future<void> exportJsonData() async {
    // String jsonFilePath = await getJsonFilePath();

    // final List<Map<String, dynamic>> maps = await database.query('messages');
    // String jsonContent = jsonEncode(maps);
    // await File(jsonFilePath).writeAsString(jsonContent);

    // await Share.shareFiles([jsonFilePath], text: 'Your Ideas Data');

    String jsonFilePath = await getDatbaseFilePath();
    await Share.shareFiles([jsonFilePath], text: 'Your Ideas Data');
  }

  Future<void> replaceOldDatabaseFileWithNewOne(
      {required String newFilePath}) async {
    print("new file path: $newFilePath");
    File newFile = File(newFilePath);
    var bytes = await newFile.readAsBytes();

    File oldFile = File(await getDatbaseFilePath());
    print("old file path: ${oldFile.path}");
    await oldFile.writeAsBytes(bytes, flush: true);

    await initializeDatabase();
  }

  Future<void> exportDatabase() async {
    await Share.shareFiles([await getDatbaseFilePath()],
        text: 'Your Ideas Database');
  }

  Future<void> insertMessage(Message msg) async {
    // await database.insert(
    //   'messages',
    //   msg.toMap(),
    //   conflictAlgorithm: ConflictAlgorithm.replace,
    // );
    realMessageList.add(msg);

    await saveMemoryMessageListIntoTheJsonFile();
  }

  Future<void> updateMessage(Message msg) async {
    // await database.update("messages", msg.toMap(),
    //     where: 'date = ?', whereArgs: [msg.date]);

    // for (var message in messageList) {
    //   if (message.date == msg.date) {
    //     message.content = msg.content;
    //     message.images = msg.images;
    //   }
    // }
    int index =
        realMessageList.indexWhere((element) => element.date == msg.date);

    if (index != -1) {
      realMessageList[index] = msg;
    }

    await saveMemoryMessageListIntoTheJsonFile();
  }

  Future<void> deleteMessage(Message msg) async {
    //String images = Message.convertListOfStringToString(msg.images);

    // await database.delete('messages',
    //     where: 'date = ? AND content = ? AND images = ?',
    //     whereArgs: [msg.date, msg.content, images]);

    int index = realMessageList.indexWhere((element) =>
        element.date == msg.date &&
        element.content == msg.content &&
        msg.images == msg.images);

    if (index != -1) {
      realMessageList.removeAt(index);
    }

    await saveMemoryMessageListIntoTheJsonFile();
  }

  Future<List<Message>> searchMessages({required String text}) async {
    List<String> keywords = text.split(" ");

    // String whereString =
    //     keywords.map((e) => "content LIKE ?").toList().join(" AND ");
    // List<String> whereArgs = keywords.map((e) => "%$e%").toList();

    // final List<Map<String, dynamic>> maps = await database.query('messages',
    //     where: whereString, whereArgs: whereArgs);

    // return maps.map((e) => Message.fromJson(e)).toList();

    return realMessageList.where((message) {
      for (String keyword in keywords) {
        if ((message.content?.contains(keyword) ?? false) == false) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  Future<List<Message>> getMessageList() async {
    // final List<Map<String, dynamic>> maps = await database.query('messages');

    // return maps.map((e) => Message.fromJson(e)).toList();
    return realMessageList.toList();
  }

  Message getAFakeMessage() {
    return Message(date: "1.1", content: "I love you.", images: []);
    //new Message(date: "2.1", content: "I don't love you anymore.")
  }

  Future<void> syncMessageList({List<Message>? newMessageList}) async {
    List<Message> newList = [];

    if (newMessageList == null) {
      newList = realMessageList;
    } else {
      newList.assignAll(newMessageList);
    }

    // we only act when the list got change
    if (newList.isNotEmpty) {
      if (deepEqualityCheck(newList, messageList)) {
        return;
      }
    }

    RxList<Message> tempMessageList = RxList();
    tempMessageList.addAll(newList.map((e) => e));
    newList.forEach((element) {
      print(convertStringToTime(time: element.date));
    });
    messageList.assignAll(tempMessageList);
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

class Message {
  String? date;
  String? content;
  List<String>? images;

  Message({this.date, this.content, this.images});

  @override
  bool operator ==(other) {
    return (other is Message) &&
        other.date == date &&
        other.content == content &&
        deepEqualityCheck(other.images, images);
  }

  static String convertListOfStringToString(List<String>? images) {
    return jsonEncode(images);
  }

  static Message fromJson(Map<String, dynamic> json) {
    List<dynamic> imageBase64StringList = jsonDecode(json['images']);
    return Message(
        date: json['date'],
        content: json['content'],
        images: imageBase64StringList.map((e) => e.toString()).toList());
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'content': content,
      'images': Message.convertListOfStringToString(images),
    };
  }
}
