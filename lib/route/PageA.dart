import 'package:and_flutter/route/PassArgumnets.dart';
import 'package:flutter/material.dart';

import 'PageB.dart';

/// 路由表方式：
/// 默认页面初始路由： initialRoute: '/pageA'
/// 其他页面： routes: { ...}

main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 简单路由',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: PageA(),
      initialRoute: '/pageA',
      routes: {
        '/pageA':(context) => PageA(),
        '/pageB':(context) => PageB(),
      },
    );
  }
}

class PageA extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route-- PageA'),
      ),
      body: ElevatedButton(
        child: Text('jump PageB'),
        onPressed: (){
          Navigator.pushNamed(context, '/pageB',arguments: ArgumnetData('data from pageA'));
        },
      ),
    );
  }
}