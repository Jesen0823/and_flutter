import 'package:flutter/material.dart';

void main() => runApp(PageViewBuilderWidget(
      items: List<String>.generate(10000, (i) => "Item $i"), key: Key('builder'),
    ));

class PageViewBuilderWidget extends StatelessWidget {
  final List<String> items;

  PageViewBuilderWidget({required Key key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      home: Scaffold(
        appBar: AppBar(title: new Text('Flutter 可滚动Widget -- PageView.builder')),
        body: PageView.builder(
          onPageChanged: (index) {
            print('current page $index ');
          },
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
