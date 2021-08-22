import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeControlelr extends GetxController {
  HomeControlelr() {
    print("Home Controller initialized");
  }

  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
