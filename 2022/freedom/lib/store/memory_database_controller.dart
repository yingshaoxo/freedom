import 'package:freedom/tools/time_tools.dart';
import 'package:get/get.dart';
import 'package:freedom/data_structures/message.dart';

class MemoryDatabaseController extends GetxController {
  MemoryDatabaseController() {
    print("memory database controller initialized");
  }

  RxList<Message> messageList = RxList([]);

  Future<void> syncMessageList({required List<Message> newMessageList}) async {
    RxList<Message> tempMessageList = RxList();

    tempMessageList.addAll(newMessageList.map((e) => e));
    newMessageList.forEach((element) {
      print(convertStringToTime(time: element.date));
    });

    messageList.assignAll(tempMessageList);
  }
}
