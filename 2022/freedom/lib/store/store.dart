import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freedom/data_structures/message.dart' as message_data_structure;
import 'package:freedom/store/json_export_and_import_controller.dart';
import 'package:freedom/store/memory_database_controller.dart';

import 'package:freedom/store/sqlite_database_controller.dart';
import 'package:freedom/store/home_controller.dart';

SqliteDatabaseControlelr sqlite_database_controlelr =
    SqliteDatabaseControlelr();

MemoryDatabaseController memory_database_controller =
    MemoryDatabaseController();

JsonExportAndImportControlelr json_export_and_import_controller =
    JsonExportAndImportControlelr();
HomeControlelr homeController = HomeControlelr();

Future<void> initialization() async {
  await sqlite_database_controlelr.initializeSettings();
  await sqlite_database_controlelr.initializeDatabase();

  EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.fadingCircle;
}

class RouterRoutings {
  static const String home = "/";
  static const String settings = "/settings";
  static const String editing = "/editing";
}

class EditingPageArguments {
  message_data_structure.Message? oldMessage;

  EditingPageArguments({this.oldMessage});
}

class RouterArguments {
  EditingPageArguments? editingPageArguments;

  RouterArguments({this.editingPageArguments});
}
