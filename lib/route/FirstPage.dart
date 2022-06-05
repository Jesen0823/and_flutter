import 'dart:async';

import 'package:and_flutter/route/PassArgumnets.dart';
import 'package:and_flutter/route/SecondPage.dart';
import 'package:flutter/material.dart';

/// 简单路由：
/// 去： Navigator.push(xxx)
/// 来： Navigator.pop(context)

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 简单路由',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route-- firstPage'),
      ),
      body: ElevatedButton(
        child: Text('jump SecondRoute'),
        onPressed: () {
          jumpToSecondPage(context);
        },
      ),
    );
  }

  void jumpToSecondPage(BuildContext context) async {
    // 跳转并等待接收跳转页面返回的参数
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SeconsPage(),
            // 传递参数
            settings:
                RouteSettings(arguments: ArgumnetData('Data from firstPage'))));
    print(
        'FirstPage: get data from PageSecond: ${(result as ArgumnetData).content}');


  }
}
