import 'package:flutter/material.dart';

void main() => runApp(RowWidget());

class RowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Flutter布局Widget -- 线性布局")),
        body: Row(
          children: <Widget>[
            Text("fuck Flutter"),
            Image.asset(
              "images/avatar-7.png",
              width: 200,
            )
          ],
        ),
      ),
    );
  }
}
