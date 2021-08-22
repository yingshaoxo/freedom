import 'package:flutter/material.dart';
import 'package:freedom/pages/editing.dart';

import 'package:freedom/pages/settings.dart';
import 'package:freedom/store/store.dart';
import 'package:get/get.dart';

import 'components/lists.dart';

import 'pages/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialization();

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
      }
    });

    super.initState();
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
                child: Icon(
                  Icons.person_outline,
                  color: Colors.green[300],
                ),
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
                        EditingPageArguments(addNewOne: true)));
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

    print("hi");

    super.dispose();
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
            onEditingComplete: () async {
              print(searchInputBoxController.text);

              var results = await databaseController.searchMessages(
                  text: searchInputBoxController.text);

              await databaseController.syncMessageList(newMessageList: results);
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
