import 'package:flutter/material.dart';
import 'package:freedom/components/lists.dart';
import 'package:get/get.dart';
import 'package:freedom/store/store.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() {
        memory_database_controller.messageList.toList();
        return MessageListView(
          messageList: memory_database_controller.messageList,
        );
      }),
    );
  }
}
