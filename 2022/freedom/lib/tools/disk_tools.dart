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
  var limit_bytes = 100000;
  // if the image size >= 100KB, we compress
  if (list.lengthInBytes >= limit_bytes) {
    var result = list;
    var final_result = result;
    var max_width = 540;
    var part = (max_width/5).toInt();
    while (true) {
      print(final_result.lengthInBytes);
      if ((final_result.lengthInBytes <= limit_bytes)) {
        break;
      }
      var result_image = await resizeImage(Uint8List.fromList(result), width: max_width);
      result = (await result_image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
      final_result = Uint8List.fromList(img.encodeJpg(img.decodePng(result)!, quality: 70));
      max_width = (max_width - part).toInt();
      if (max_width == 0) {
        break;
      }
    }
    print("\n");
    print(final_result.lengthInBytes);
    print("\n______\n");
    return final_result;
  } else {
    return list;
  }
}

the_widgets.Image getImageFromBase64String(String base64String) {
  return the_widgets.Image.memory(getUint8ListFromBase64String(base64String));
}

/// If only width or height are specified, the resized image will keep the aspect ratio.
Future<ui.Image> resizeImage(Uint8List rawImage,
    {int? width, int? height}) async {
  final codec = await ui.instantiateImageCodec(rawImage,
      targetWidth: width, targetHeight: height);
  final resizedImage = (await codec.getNextFrame()).image;
  return resizedImage;
}

/*
String? uint8_list_image_to_yingshaoxo_image_txt(Uint8List list) {
  var a_image = img.decodeImage(list);
  if (a_image == null) {
    return null;
  }
  int height = a_image.height;
  int width = a_image.width;
  Map<String, String> the_color_dict = {};
  int counting = 0;
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      var pixel = a_image.getPixel(x, y);
      String rgba_string = pixel.r.toString() + "," + pixel.g.toString() + "," + pixel.b.toString() + "," + "255";
      if (!the_color_dict.containsKey(rgba_string)) {
        the_color_dict[rgba_string] = counting.toString();
        counting += 1;
      }
    }
  }

  String text_data = "format: yingshaoxo_image; version: 2024; help: the second part has the height and width. the third part contains a dict, you have to convert it into a dict where value is what you get by using new_line split, and the key is the element index start from 0. then for part 4, they are real data, each one represent a pixel index, it has rows and columns of pixels split by new_line and space, you have to use the dict you got before to convert those index number into real pixel data. as for some special symbol in real data, 2_200 means 2 repeated for 200 times in the same row, 3_d_4 means the whole row is 3 and the line in down direction repeated 4 times.";
  text_data += "\n_______\n\n";
  text_data += "height,"+height.toString()+","+"width,"+width.toString();
  text_data += "\n_______\n\n";
  the_color_dict.keys.forEach((key) {
    text_data += key + "\n";
  });
  text_data += "_______\n\n";
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      var pixel = a_image.getPixel(x, y);
      String rgba_string = pixel.r.toString() + "," + pixel.g.toString() + "," + pixel.b.toString() + "," + "255";
      text_data += the_color_dict[rgba_string].toString() + " ";
    }
    text_data += "\n";
  }
  return text_data;
  
  /*
  height, width = self.get_shape()

  the_color_dict = dict()
  for row_index, row in enumerate(self.raw_data):
      for column_index, color in enumerate(row):
          color = tuple(color)
          if color in the_color_dict.keys():
              the_color_dict[color] += 1
          else:
              the_color_dict[color] = 1
  the_color_dict_list = [(key,value) for key, value in the_color_dict.items()]
  the_color_dict_list.sort(key=lambda x: -x[1])

  the_real_color_dict = dict()
  index = 0
  for key,value in the_color_dict_list:
      key = ",".join([str(one) for one in key])
      the_real_color_dict[key] = index
      index += 1

  elif file_path.endswith(".txt"):
    text_data = "format: yingshaoxo_image; version: 2024; help: the second part has the height and width. the third part contains a dict, you have to convert it into a dict where value is what you get by using new_line split, and the key is the element index start from 0. then for part 4, they are real data, each one represent a pixel index, it has rows and columns of pixels split by new_line and space, you have to use the dict you got before to convert those index number into real pixel data. as for some special symbol in real data, 2_200 means 2 repeated for 200 times in the same row, 3_d_4 means the whole row is 3 and the line in down direction repeated 4 times."
    text_data += "\n_______\n\n"
    text_data += "height,"+str(height)+","+"width,"+str(width)
    text_data += "\n_______\n\n"
    for key in the_real_color_dict.keys():
        text_data += key + "\n"
    text_data += "_______\n\n"
    if extreme == False:
        for row_index, row in enumerate(self.raw_data):
            for column_index, color in enumerate(row):
                color = ",".join([str(one) for one in color])
                text_data += str(the_real_color_dict[color]) + " "
            text_data += "\n"
  */
}

*/

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
