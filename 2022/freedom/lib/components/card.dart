import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freedom/components/image.dart';
import 'package:freedom/store/store.dart';
import 'package:clipboard/clipboard.dart';
import 'package:freedom/tools/disk_tools.dart';
import 'package:get/get.dart';

import 'package:freedom/data_structures/message.dart' as message_data_structure;

class MyCard extends StatelessWidget {
  final message_data_structure.Message message;
  MyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onLongPress: () async {
          FlutterClipboard.copy(message.content)
              .then((value) => Fluttertoast.showToast(
                    msg: "copied",
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 10,
                  ));
        },
        onDoubleTap: () async {
          print('go to edit page');
          Get.toNamed(RouterRoutings.editing,
              arguments: RouterArguments(
                  editingPageArguments:
                      EditingPageArguments(oldMessage: message)));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(message.date,
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal)),
                  ),
                  GestureDetector(
                    onTap: () async {
                      sqlite_database_controlelr.deleteMessage(message);
                      memory_database_controller.refresh_the_list_view();
                    },
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.grey,
                      size: 20,
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  message.content,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              if (message.images.isNotEmpty) ...[
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 100,
                  child: GridView.count(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      crossAxisCount: 3,
                      // Generate 100 widgets that display their index in the List.
                      children: (message.images)
                          .map((e) => Container(
                              color: Colors.grey.withAlpha(30),
                              child: MyImage(
                                  image: Image(
                                      image: getImageFromBase64String(e).image,
                                      fit: BoxFit.contain))))
                          .toList()),
                ),
              ] else ...[
                Container()
              ],
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.chat_bubble_outline_outlined,
                            color: Colors.grey, size: 18),
                        Container(
                          margin: EdgeInsets.only(left: 3.0),
                          child: Text("0",
                              style: TextStyle(
                                  color: Colors.black.withAlpha(100))),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        FlutterClipboard.copy(message.content)
                            .then((value) => Fluttertoast.showToast(
                                  msg: "copied",
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 10,
                                ));
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.share_outlined,
                              color: Colors.grey, size: 18),
                          Container(
                            margin: EdgeInsets.only(left: 3.0),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
