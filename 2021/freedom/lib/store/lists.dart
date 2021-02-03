import 'package:flutter/material.dart';

class Message {
  String date;
  String content;

  Message({this.date, this.content});
}

class ListsModel extends ChangeNotifier {
  List<Message> get messages {
    return [
      new Message(date: "1.1", content: "I love you."),
      new Message(date: "2.1", content: "I don't love you anymore.")
    ];
  }

  void add(int item) {
    notifyListeners();
  }
}
