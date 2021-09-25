import 'package:flutter/material.dart';

/// ListView 可以线性排列 ⼦Widget 的可滚动Widget。ListView 可 以和数据绑定⽤来实现瀑布流。
/// 使⽤默认的构造函数，给 children 属性赋值
///
main() =>runApp(ListViewDefaultWidget());

class ListViewDefaultWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      home: Scaffold(
        appBar: AppBar(title: Text('可滚动控件 ListView'),),
        body: ListView(
          children: [
            ListTile(title: Text('Title 1'),),
            ListTile(title: Text('Title 2'),),
            ListTile(title: Text('Title 3'),),
            ListTile(title: Text('Title 4'),),
            ListTile(title: Text('Title 5'),),
            ListTile(title: Text('Title 6'),),
            ListTile(title: Text('Title 7'),),
            ListTile(title: Text('Title 8'),),
            ListTile(title: Text('Title 9'),),
            ListTile(title: Text('Title 1'),),
            ListTile(title: Text('Title 2'),),
            ListTile(title: Text('Title 3'),),
            ListTile(title: Text('Title 4'),),
            ListTile(title: Text('Title 5'),),
            ListTile(title: Text('Title 6'),),
            ListTile(title: Text('Title 7'),),
            ListTile(title: Text('Title 8'),),
            ListTile(title: Text('Title 9'),),
          ],
        ),
      ),
    );
  }
}