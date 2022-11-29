import 'package:freedom/tools/time_tools.dart';
import 'dart:convert';

class Message {
  String type;
  String date;
  String content;
  List<String> images;

  /*
  {
      type: 'twitter', # qzone, twitter, kivydiary, freedom, and so on...
      date: '2022-11-28   09:30',
      content: 'Morning',
      images: [image_base64_string1,
               image_base64_string2]
  }
  */

  Message(
      {required this.type,
      required this.date,
      required this.content,
      required this.images});

  @override
  bool operator ==(other) {
    return (other is Message) &&
        other.type == type &&
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
        type: json['type'],
        date: json['date'],
        content: json['content'],
        images: imageBase64StringList.map((e) => e.toString()).toList());
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'date': date,
      'content': content,
      'images': Message.convertListOfStringToString(images),
    };
  }
}

class HashIdToBase64ImageStringClass {
  String hash_id;
  String base64_image_string;

  /*
  {
      hash_id: '5fe5c00', # we use first 31 chars
      base64_image_string: 'VBORw0KGgoAAAANS...'
  }
  */

  HashIdToBase64ImageStringClass({
    required this.hash_id,
    required this.base64_image_string,
  });

  @override
  bool operator ==(other) {
    return (other is HashIdToBase64ImageStringClass) &&
        other.hash_id == hash_id &&
        other.base64_image_string == base64_image_string;
    ;
  }

  static HashIdToBase64ImageStringClass fromJson(Map<String, dynamic> json) {
    return HashIdToBase64ImageStringClass(
        hash_id: json['hash_id'],
        base64_image_string: json['base64_image_string']);
  }

  Map<String, dynamic> toMap() {
    return {
      'hash_id': hash_id,
      'base64_image_string': base64_image_string,
    };
  }
}
