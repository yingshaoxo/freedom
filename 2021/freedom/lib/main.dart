import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:freedom/pages/settings.dart';
import 'package:freedom/store/store.dart';
import 'package:freedom/pages/editing.dart';
import 'components/lists.dart';
import 'pages/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialization();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      GetMaterialApp(
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
      title: 'Flutter Demo',
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
        //print("home");
        var results = await databaseController.getMessageList();
        await databaseController.syncMessageList(newMessageList: results);
      } else if (tabController.index == 1) {
        //print("search");
        await databaseController.syncMessageList(newMessageList: []);
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
        List<String>? splits = file.path.split(".");
        if (splits.isNotEmpty) {
          if (splits.last == "db") {
            print("database we received: " + file.path);

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
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text("Confirm"),
                      onPressed: () async {
                        await databaseController
                            .replaceOldDatabaseFileWithNewOne(
                                newFilePath: file.path);
                        Navigator.pop(context);
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
    DateTime now = DateTime.now();

    bool isHKTime = true;
    if ((now.hour >= 8) && (now.hour <= 20)) {
      isHKTime = true;
    } else {
      isHKTime = false;
    }

    return 'assets/images/us_flag.png';

    if (isHKTime) {
      return 'assets/images/cn_flag.png';
    } else {
      return 'assets/images/us_flag.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title!,
            style: TextStyle(color: Colors.blue),
          ),
          backgroundColor: Colors.white, // status bar color
          iconTheme: IconThemeData(color: Colors.blue),
          brightness: Brightness.light, // status bar brightness
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Image(
                    image: AssetImage(getTheImagePath()), fit: BoxFit.fill),
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
            ],
          ),
        ),
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
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() {
        return MessageListView(
          messageList: databaseController.messageList
              .map((element) => element.value)
              .toList(),
        );
      }),
    );
  }
}

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final searchInputBoxController = TextEditingController();

  @override
  void dispose() {
    searchInputBoxController.dispose();

    super.dispose();
  }

  Future<void> doASearch() async {
    print(searchInputBoxController.text);

    var results = await databaseController.searchMessages(
        text: searchInputBoxController.text);

    await databaseController.syncMessageList(newMessageList: results);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: TextField(
            controller: searchInputBoxController,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.bottom,
            autocorrect: false,
            //autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search here',
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.blue.withAlpha(200), width: 0.5),
              ),
            ),
            onChanged: (_) async {
              await doASearch();
            },
            onEditingComplete: () async {
              await doASearch();
            },
            /*
            expands: true,
            maxLines: null,
            minLines: null,
            */
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(child: Obx(() {
          return MessageListView(
            messageList: databaseController.messageList
                .map((element) => element.value)
                .toList(),
          );
        }))
      ],
    );
  }
}
