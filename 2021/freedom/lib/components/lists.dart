import 'package:flutter/material.dart';

import 'package:freedom/store/database_controller.dart';
import 'card.dart';

class MessageListView extends StatefulWidget {
  final List<Message> messageList;

  MessageListView({Key? key, required this.messageList}) : super(key: key);

  @override
  _MessageListViewState createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theMessageList = widget.messageList.reversed.toList();
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.grey, style: BorderStyle.solid, width: 0.3))),
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          thickness: 0.4,
          color: Colors.grey,
        ),
        itemCount: theMessageList.length,
        itemBuilder: (BuildContext context, int index) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 50.0,
            ),
            child: InkWell(child: MyCard(message: theMessageList[index])),
          );
        },
      ),
    );
  }
}
