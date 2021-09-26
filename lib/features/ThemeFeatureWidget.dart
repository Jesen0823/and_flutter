import 'package:flutter/material.dart';

/// Theme的获取与使用

void main() => runApp(ThemeFeatureWidget());

class ThemeFeatureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter 功能类Widget -- Theme'),
        ),
        body: ChildText(),
      ),
    );
  }
}

class ChildText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '获取Theme颜色为我着色',
      style: TextStyle(color: Theme.of(context).primaryColor),
    );
  }
}
