import 'package:flutter/material.dart';

///
/// SingleChildScrollView 是只能包含⼀个 ⼦Widget 的可滚 动Widget。
/// 如果有很多 ⼦Widget，那么需要⽤ ListBody 或者 Column 或者其他 Widget 来嵌套这些 ⼦Widget
///
main() => runApp(new SingleChildScrollViewWidget());

class SingleChildScrollViewWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      home: Scaffold(
        appBar: AppBar(title: Text('滚动部件 SingleChildScrollView'),),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text(
                'Shanghai is a model city in china and i will go to it.\n' * 100,
                style: TextStyle(fontSize: 26.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}