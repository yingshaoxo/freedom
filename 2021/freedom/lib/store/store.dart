import 'package:freedom/store/database_controller.dart';
import 'package:freedom/store/home_controller.dart';

DatabaseControlelr databaseController = DatabaseControlelr();
HomeControlelr homeController = HomeControlelr();

Future<void> initialization() async {
  await databaseController.initializeDatabase();
}

class RouterRoutings {
  static const String home = "/";
  static const String settings = "/settings";
  static const String editing = "/editing";
}

class EditingPageArguments {
  late bool addNewOne;

  EditingPageArguments({required this.addNewOne});
}

class RouterArguments {
  EditingPageArguments? editingPageArguments;

  RouterArguments({this.editingPageArguments});
}