import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freedom/pages/home.dart';
import 'package:freedom/pages/search.dart';
import 'package:get/get.dart';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:freedom/pages/settings.dart';
import 'package:freedom/store/store.dart';
import 'package:freedom/pages/editing.dart';
import 'pages/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialization();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      GetMaterialApp(
        builder: EasyLoading.init(),
        initialRoute: RouterRoutings.home,
        getPages: [
          GetPage(
            name: RouterRoutings.home,
            page: () => MyApp(),
          ),
          GetPage(
            name: RouterRoutings.editing,
            page: () => EditingPage(),
          ),
          GetPage(
            name: RouterRoutings.settings,
            page: () => SettingPage(),
          ),
        ],
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freedom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Freedom'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late StreamSubscription _intentDataStreamSubscription;

  late TabController tabController;

  @protected
  @mustCallSuper
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() async {
      if (tabController.index == 0) {
        //print("home tab");
        await sqlite_database_controlelr.sync_messages_data_to_view();
      } else if (tabController.index == 1) {
        //print("search tab");
        await memory_database_controller.syncMessageList(newMessageList: []);
      }
    });

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> files) async {
      if (files.isEmpty) {
        return;
      }
      if (files.length > 1) {
        return;
      }
      for (SharedMediaFile file in files) {
        // Fluttertoast.showToast(
        //   msg: file.path,
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.CENTER,
        // );

        List<String>? splits = file.path.split(".");
        if (splits.isNotEmpty) {
          if (splits.last == "json") {
            print("database we received: " + file.path);

            // Fluttertoast.showToast(
            //   msg: "database we received: " + file.path,
            //   toastLength: Toast.LENGTH_LONG,
            //   gravity: ToastGravity.CENTER,
            // );
            if (homeController.gotBackupData == true) {
              continue;
            }
            homeController.gotBackupData = true;

            // show the dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Warning"),
                  content: Text(
                      "Are your sure you want to replace old data with the data you gave?"),
                  actions: [
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () async {
                        homeController.gotBackupData = false;
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text("Confirm"),
                      onPressed: () async {
                        EasyLoading.instance.loadingStyle =
                            EasyLoadingStyle.dark;
                        EasyLoading.show(status: 'processing...');

                        homeController.gotBackupData = false;
                        await json_export_and_import_controller
                            .refill_sqlite_database_with_the_content_inside_of_a_json_file(
                                newFilePath: file.path);
                        Navigator.pop(context);

                        await EasyLoading.dismiss();
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    super.initState();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  String getTheImagePath() {
    // DateTime now = DateTime.now();
    // bool isHKTime = true;
    // if ((now.hour >= 8) && (now.hour <= 20)) {
    //   isHKTime = true;
    // } else {
    //   isHKTime = false;
    // }

    return 'assets/images/us_flag.png';

    // if (isHKTime) {
    //   return 'assets/images/cn_flag.png';
    // } else {
    //   return 'assets/images/us_flag.png';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title!,
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white, // status bar color
        iconTheme: IconThemeData(color: Colors.blue),
        // brightness: Brightness.light, // status bar brightness
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
      ),
      drawer: Drawer(
          child: Column(
        children: [
          DrawerHeader(
            child:
                Image(image: AssetImage(getTheImagePath()), fit: BoxFit.fill),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(RouterRoutings.settings);
            },
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "yingshaoxo",
                    style: TextStyle(color: Colors.grey[300]),
                  )))
        ],
      )),
      bottomNavigationBar: TabBar(
        controller: tabController,
        tabs: [
          Tab(
            icon: Icon(
              Icons.home,
              color: Colors.blue,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.search,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [HomeTab(), SearchTab()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.toNamed(RouterRoutings.editing,
              arguments: RouterArguments(
                  editingPageArguments:
                      EditingPageArguments(oldMessage: null)));
        },
        tooltip: 'add',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
