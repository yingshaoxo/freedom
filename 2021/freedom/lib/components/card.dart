import 'package:flutter/material.dart';
import 'package:freedom/store/lists.dart';

class MyCard extends StatelessWidget {
  Message message;
  MyCard({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(message.date,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  message.content,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.chat_bubble_outline_outlined,
                            color: Colors.grey, size: 18),
                        Container(
                          margin: EdgeInsets.only(left: 3.0),
                          child:
                              Text("15", style: TextStyle(color: Colors.black)),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.share_outlined,
                            color: Colors.grey, size: 18),
                        Container(
                          margin: EdgeInsets.only(left: 3.0),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
