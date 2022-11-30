import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freedom/components/image.dart';
import 'package:freedom/data_structures/message.dart';
import 'package:freedom/store/store.dart';
import 'package:freedom/tools/disk_tools.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditingPage extends StatefulWidget {
  EditingPage({Key? key}) : super(key: key);

  @override
  _EditingPageState createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  RouterArguments arguments = Get.arguments;

  late String title;

  final TextEditingController textInputController = TextEditingController();
  final ImagePicker image_picker = ImagePicker();

  List<String> seletctedImages = [];

  Message? oldMessage;

  @protected
  @mustCallSuper
  @override
  void initState() {
    oldMessage = arguments.editingPageArguments?.oldMessage;

    title = oldMessage == null ? "Add" : "Edit";

    if (oldMessage != null) {
      if (oldMessage?.images != null) {
        seletctedImages.assignAll(oldMessage?.images ?? []);
      }

      if (oldMessage?.content != null) {
        textInputController.text = oldMessage?.content ?? "";
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    textInputController.dispose();

    super.dispose();
  }

  String getDate() {
    String now = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

    if (oldMessage != null) {
      return oldMessage?.date ?? now;
    } else {
      return now;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        actions: [
          TextButton(
              onPressed: () async {
                EasyLoading.show(status: "processing...");

                String text = textInputController.text.trim();

                if (text != "" || seletctedImages.isNotEmpty) {
                  Message msg = Message(
                      type: "freedom",
                      date: getDate(),
                      content: text,
                      images: seletctedImages);

                  if (oldMessage != null) {
                    await sqlite_database_controlelr.updateMessage(msg);
                  } else {
                    await sqlite_database_controlelr.insertMessage(msg);
                  }

                  await sqlite_database_controlelr.sync_messages_data_to_view();

                  Get.offAndToNamed(RouterRoutings.home);

                  EasyLoading.dismiss();
                }
              },
              child: Text("Save"))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: homeController.getScreenHeight(context) * 0.2,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 2,
                ),
                child: TextField(
                  controller: textInputController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: null,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  autofocus: true,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: "What's happenning?",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blue.withAlpha(200), width: 0.5),
                    ),
                    //isCollapsed: false,
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  /*
                expands: true,
                maxLines: null,
                minLines: null,
                */
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: homeController.getScreenWidth(context),
              child: TextButton(
                onPressed: () async {
                  // Pick multiple images
                  final List<XFile>? xFileList =
                      await image_picker.pickMultiImage();

                  seletctedImages.clear();

                  for (XFile xfile in xFileList ?? []) {
                    Uint8List imageBytes = await xfile.readAsBytes();

                    imageBytes = await uint8ListImageCompress(imageBytes);

                    String imageBase64 =
                        getBase64StringFromUint8List(imageBytes);

                    seletctedImages.add(imageBase64);
                  }

                  setState(() {});
                },
                child: Text(
                  "PICK AN IMAGE",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue.withAlpha(50))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: GridView.count(
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    crossAxisCount: 3,
                    // Generate 100 widgets that display their index in the List.
                    children: seletctedImages.map((e) {
                      Image image = Image(
                          image: getImageFromBase64String(e).image,
                          fit: BoxFit.contain);
                      return MyImage(image: image);
                    }).toList()))
          ],
        ),
      ),
    );
  }
}
