import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freedom/components/lists.dart';
import 'package:get/get.dart';
import 'package:freedom/store/store.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final searchInputBoxController = TextEditingController();

  @override
  void dispose() {
    searchInputBoxController.dispose();

    super.dispose();
  }

  Future<void> doASearch() async {
    print(searchInputBoxController.text);

    var results = await sqlite_database_controlelr.searchMessages(
        text: searchInputBoxController.text);

    await memory_database_controller.syncMessageList(newMessageList: results);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: TextField(
            controller: searchInputBoxController,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.bottom,
            autocorrect: false,
            //autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search here',
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.blue.withAlpha(200), width: 0.5),
              ),
            ),
            onChanged: (_) async {
              await doASearch();
            },
            onEditingComplete: () async {
              await doASearch();
            },
            /*
            expands: true,
            maxLines: null,
            minLines: null,
            */
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(child: Obx(() {
          return MessageListView(
            messageList: memory_database_controller.messageList
                .map((element) => element)
                .toList(),
          );
        }))
      ],
    );
  }
}
