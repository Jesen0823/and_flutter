import 'package:flutter/material.dart';

/// SliverChildDelegate 是⼀个抽象类， SliverChildDelegate 的 build ⽅法可以对单个 ⼦Widget 进⾏⾃定 义处理，
/// ⽽且 SliverChildDelegate 有个默认实现 SliverChildListDelegate

void main() => runApp(ListViewCustomWidget(
  items: List<String>.generate(10000, (i) => "Item $i"), key: Key('custom'),
));

class ListViewCustomWidget extends StatelessWidget {
  final List<String> items;

  ListViewCustomWidget({required Key key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      home: Scaffold(
        appBar: AppBar(title: new Text('Flutter 可滚动Widget -- ListView')),
        body: ListView.custom(
          childrenDelegate: SliverChildListDelegate(<Widget>[
            ListTile(title: Text('Title1')),
            ListTile(title: Text('Title2')),
            ListTile(title: Text('Title3')),
            ListTile(title: Text('Title4')),
            ListTile(title: Text('Title5')),
            ListTile(title: Text('Title6')),
            ListTile(title: Text('Title7')),
            ListTile(title: Text('Title8')),
            ListTile(title: Text('Title9')),
            ListTile(title: Text('Title10')),
            ListTile(title: Text('Title11')),
            ListTile(title: Text('Title12')),
            ListTile(title: Text('Title13')),
            ListTile(title: Text('Title14')),
            ListTile(title: Text('Title15')),
            ListTile(title: Text('Title16')),
            ListTile(title: Text('Title17')),
            ListTile(title: Text('Title18')),
            ListTile(title: Text('Title19')),
          ]),
        ),
      ),
    );
  }
}
