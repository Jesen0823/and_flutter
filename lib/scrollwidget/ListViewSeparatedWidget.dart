import 'package:flutter/material.dart';

/// separatorBuilder就是⽤于构建分割项的，
/// ⽽且 itemBuilder、 separatorBuilder、itemCount 都是必选的

main() => runApp(ListViewSeparatedWidget(
      key: Key('nmb'),
      items: List<String>.generate(10000, (index) => 'Item $index'),
    ));

class ListViewSeparatedWidget extends StatelessWidget {
  final List<String> items;

  ListViewSeparatedWidget({required Key key, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      home: Scaffold(
        appBar: AppBar(
          title: Text('可滚动Widget ListView with Separated'),
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${items[index]}'),
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                constraints: BoxConstraints.tightFor(height: 6),
                color: Colors.blue,
              );
            },
            itemCount: items.length),
      ),
    );
  }
}
