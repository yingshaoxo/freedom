import 'dart:ui';

import 'package:path/path.dart' as built_in_path_module;
import 'dart:ui' as ui;

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart' as the_widgets;
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as the_path_module;
import 'package:image/image.dart' as img;

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

Future<Uint8List> uint8ListImageToPngFormat(Uint8List list) async {
  if (list.lengthInBytes >= 100000) {
    // if the image size >= 100KB, we compress
    var result = list;
    var max_width = 1080;
    var counting = 0;
    while (true) {
      print(result.lengthInBytes);
      if ((result.lengthInBytes <= 1000000) && (counting >= 1)) {
        //for png, if it is less than 1MB, then we handle it to jpg
        break;
      }
      var result_image = await resizeImage(Uint8List.fromList(result), width: max_width);
      var height = result_image.height;
      var width = result_image.width;
      result = (await result_image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
      max_width = (max_width / 2).toInt();
      if (max_width == 0) {
        break;
      }
      counting += 1;
    }
    result = Uint8List.fromList(img.encodeJpg(img.decodePng(result.toList())!, quality: 70));
    print("\n");
    print(result.lengthInBytes);
    print("\n______\n");
    return result;
  } else {
    return list;
  }
}

the_widgets.Image getImageFromBase64String(String base64String) {
  return the_widgets.Image.memory(getUint8ListFromBase64String(base64String));
}

/// If only width or height are specified, the resized image will keep the aspect ratio.
Future<Image> resizeImage(Uint8List rawImage,
    {int? width, int? height}) async {
  final codec = await ui.instantiateImageCodec(rawImage,
      targetWidth: width, targetHeight: height);
  final resizedImage = (await codec.getNextFrame()).image;
  return resizedImage;
}

/*
Uint8List get_simplified_image(Uint8List list) {
  // remove noise pixels that show less

  //final image = img.Image(width, height);
  var a_image = img.decodePng(list);
  if (a_image == null) {
    return list;
  }

  var height = a_image.height;
  var width = a_image.width;

  var int_color = a_image.getPixel(0, 0);
  var red = img.getRed(int_color);
  var green = img.getGreen(int_color);
  var blue = img.getBlue(int_color);

  a_image.setPixelRgba(0, 0, red, green, blue);

  final png = img.encodePng(a_image);
  return Uint8List.fromList(png);
}
*/