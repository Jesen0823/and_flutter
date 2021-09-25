import 'package:flutter/material.dart';

/// 使⽤ ListView.builder,可⽤于和数据绑定实现⼤量或 ⽆限的列表
/// 是因为 ListView.builder 只会构建那些实际可⻅的 ⼦Widget。

void main() => runApp(ListViewBuilderWidget(
  items: List<String>.generate(10000, (i) => "Item $i"), key: Key('nmb'),
));

class ListViewBuilderWidget extends StatelessWidget {
  final List<String> items;

  ListViewBuilderWidget({required Key key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      home: Scaffold(
        appBar: AppBar(title: new Text('Flutter 可滚动Widget -- ListView')),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${items[index]}'),
            );
          },
        ),
      ),
    );
  }
}
