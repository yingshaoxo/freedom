import 'package:collection/collection.dart';
import 'package:freedom/data_structures/message.dart';

DateTime? convertStringToTime({required String? time}) {
  //const dateTimeString = '2020-07-17T03:18:31.177769-04:00';
  if (time == null) {
    return null;
  }
  return DateTime.parse(time);
}

Function deepEqualityCheck = const DeepCollectionEquality().equals;

List<Message> getTodayInHistory({required List<Message> messageList}) {
  DateTime now = new DateTime.now();
  int targetMonth = now.month;
  int targetDay = now.day;
  return messageList.where((element) {
    DateTime? oneDay = convertStringToTime(time: element.date);
    if (oneDay == null) {
      return false;
    }
    if (oneDay.month == targetMonth && oneDay.day == targetDay) {
      return true;
    }
    return false;
  }).toList();
}
