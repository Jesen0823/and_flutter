import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

main() => runApp(WrapWidget());

class WrapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter 流式布局'),
        ),
        body: Wrap(
          direction: Axis.horizontal,
          spacing: 5, // 主轴方向间距
          runSpacing: 10, // 交叉轴方向间距
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.start,
          children: [
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text('A'),
              ),
              label: Text("AAAAAAAAA"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),

            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text('B'),
              ),
              label: Text("BBBBBBBBB"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),

            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text('C'),
              ),
              label: Text("CCCCCCCCCCC"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),

            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text('D'),
              ),
              label: Text("DDDDDDDDDDDD"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),

            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text('F'),
              ),
              label: Text("FFFFFF"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
