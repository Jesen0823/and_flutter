import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

main() =>runApp(CenterWidget());

class CenterWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      home: Scaffold(
        appBar: AppBar(title: Text('容器 Center'),),
        body: Center(
          child: Text(
            'Hello Center',
            style: TextStyle(color: Colors.red, fontSize: 50),
          ),
        ),
      ),
    );
  }
}