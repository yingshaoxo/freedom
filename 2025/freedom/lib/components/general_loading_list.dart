import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:freedom/components/card.dart';
import 'package:freedom/store/store.dart';

class LoadingAndRefreshList extends StatefulWidget {
  const LoadingAndRefreshList({Key? key}) : super(key: key);

  @override
  _LoadingAndRefreshListState createState() => _LoadingAndRefreshListState();
}

class _LoadingAndRefreshListState extends State<LoadingAndRefreshList> {
  bool? loadingSuccess;

  @override
  initState() {
    super.initState();

    loadingSuccess = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void _onRefresh() async {}

  void _onLoading() async {
    await memory_database_controller.load_more_messages();
  }

  @override
  Widget build(BuildContext context) {
    Widget theWidgetWeReturn = Container();

    // var theMessageList =
    //     memory_database_controller.messageList.reversed.toList();
    var theMessageList = memory_database_controller.messageList.toList();

    if (loadingSuccess != null) {
      if (loadingSuccess == true) {
        theWidgetWeReturn = Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                      width: 0.3))),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                EasyDebounce.debounce(
                    'home: call_loading_function', // <-- An ID for this particular debouncer
                    Duration(milliseconds: 500), // <-- The debounce duration
                    () {
                  print("require loading");
                  _onLoading();
                } // <-- The target method
                    );
              }
              return true;
            },
            child: CustomScrollView(
              shrinkWrap: false,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Column(
                        children: [
                          if ((index != 0)) ...[
                            Divider(
                              thickness: 0.4,
                              color: Colors.grey,
                            ),
                          ],
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 50.0,
                            ),
                            child: MyCard(message: theMessageList[index]),
                          ),
                        ],
                      );
                    },
                    childCount: theMessageList.length, // 1000 list items
                  ),
                ),
                // SliverToBoxAdapter(
                //   child: Center(child: Text("loading...")),
                // )
              ],
            ),
          ),
        );
      } else {
        theWidgetWeReturn = Container(
          color: Colors.white,
          child: Center(child: Text("Loading...")),
        );
      }
    }

    return Container(
      color: Colors.white,
      child: theWidgetWeReturn,
    );
  }
}
