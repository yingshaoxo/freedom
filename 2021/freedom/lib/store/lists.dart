import 'package:flutter/material.dart';

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';

class Message {
  String date;
  String content;

  Message({this.date, this.content});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'content': content,
    };
  }
}

class ListsModel extends ChangeNotifier {
  List<Message> temp_messages = [];
  ListsModel() {}

  Future<void> insertMessage(Message msg) async {
    final Database db = await database;
    await db.insert(
      'messages',
      msg.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future<List<Message>> getMessageList() async {
    // Get a reference to the database.
    final Database db = database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('messages');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Message(
        date: maps[i]['date'],
        content: maps[i]['content'],
      );
    });
  }

  List<Message> get messages {
    getMessageList().then((listofvalues) {
      temp_messages = listofvalues;
      notifyListeners();
    }).catchError((errors) {
      temp_messages = [
        new Message(date: "1.1", content: "I love you."),
        new Message(date: "2.1", content: "I don't love you anymore.")
      ];
      notifyListeners();
    });
    return temp_messages;
  }

  void add(int item) {
    notifyListeners();
  }
}
