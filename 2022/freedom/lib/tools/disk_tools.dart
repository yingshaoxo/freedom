import 'package:path/path.dart' as built_in_path_module;

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as the_path_module;

Future<String> get_my_json_path() async {
    var directory_0 = await getTemporaryDirectory();
    var directory_1 = await getExternalStorageDirectory();
    var directory = directory_0;
    if (directory_1?.path != null) {
      directory = directory_1!;
    }
    var the_json_path = the_path_module.join(directory.path, "database.json");
    return the_json_path;
}

String path_join({required String path1, required String path2}) {
  return built_in_path_module.join(path1, path2);
}

String getBase64StringFromUint8List(Uint8List data) {
  return base64Encode(data);
}

Uint8List getUint8ListFromBase64String(String base64String) {
  return base64Decode(base64String);
}

Future<Uint8List> uint8ListImageCompress(Uint8List list) async {
  /*
  if (list.lengthInBytes > 100000) {
    // if the image size > 100KB, we compress
    //return Uint8List(0);
    var result = await FlutterImageCompress.compressWithList(list,
        minWidth: 720, quality: 60);
    return result;
  } else {
    return list;
  }
  */
  var result = await FlutterImageCompress.compressWithList(list,
      minWidth: 720, quality: 60);
  return result;
}

Image getImageFromBase64String(String base64String) {
  return Image.memory(getUint8ListFromBase64String(base64String));
}
