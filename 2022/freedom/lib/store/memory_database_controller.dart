import 'package:freedom/store/store.dart';
import 'package:get/get.dart';
import 'package:freedom/data_structures/message.dart';

class MemoryDatabaseController extends GetxController {
  MemoryDatabaseController() {
    print("memory database controller initialized");
  }

  int stream_size_for_a_bunch_of_messages = 3;
  RxList<Message> messageList = RxList([]);

  Future<void> syncMessageList({required List<Message> newMessageList}) async {
    RxList<Message> tempMessageList = RxList();

    tempMessageList.addAll(newMessageList);

    messageList.assignAll(tempMessageList);
  }

  Future<void> add_new_message_list_in(
      {required List<Message> new_message_list}) async {
    RxList<Message> tempMessageList = RxList();

    tempMessageList.addAll(this.messageList);
    tempMessageList.addAll(new_message_list);

    messageList.assignAll(tempMessageList);
  }

  Future<void> show_default_message_list() async {
    if (sqlite_database_controlelr.onlyShowTodayInHistory) {
      //show history in today
      var message_list = await sqlite_database_controlelr
          .search_messages_that_sent_on_the_same_day_of_the_years(
              go_back_to_past_order: true);
      await syncMessageList(newMessageList: message_list);
      return;
    }

    RxList<Message> tempMessageList = RxList();

    var first_20_messages =
        await sqlite_database_controlelr.get_message_list_by_offset_and_limit(
            offset: 0, limit: 3, go_back_to_past_order: true);

    tempMessageList.addAll(first_20_messages);
    print(first_20_messages);

    messageList.assignAll(tempMessageList);
  }

  Future<void> load_more_messages() async {
    if (sqlite_database_controlelr.onlyShowTodayInHistory) {
      // we show all history-in-today message
      // no need to load more
      return;
    }

    var current_messages_number = memory_database_controller.messageList.length;

    List<Message> new_msg_list =
        await sqlite_database_controlelr.get_message_list_by_offset_and_limit(
            offset: current_messages_number,
            limit: stream_size_for_a_bunch_of_messages,
            go_back_to_past_order: true);

    await add_new_message_list_in(new_message_list: new_msg_list);
  }

  Future<void> refresh_the_list_view() async {
    RxList<Message> tempMessageList = RxList();

    for (Message msg_ in this.messageList) {
      Message? the_msg = await sqlite_database_controlelr
          .search_message_by_type_and_date(msg: msg_);
      if (the_msg != null) {
        // update database message to memory
        tempMessageList.add(the_msg);
      } else {
        // delete memory message if it not in database
      }
    }

    messageList.assignAll(tempMessageList);
  }
}
