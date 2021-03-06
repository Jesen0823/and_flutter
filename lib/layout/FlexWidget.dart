import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 弹性布局

main() => runApp(new FlexWidget());

class FlexWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Test',
      home: new Scaffold(
        appBar: new AppBar(title: Text('弹性布局'),),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30.0,
              height: 30.0,
            ),
            Container(
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                      child: Container(
                        color: Colors.yellow,
                        child: Text('使用 Flexible 包裹子Widget'),
                      )
                  ),
                ],
              ),
            ),
            Container(
              width: 30.0,
              height: 30.0,
            ),
            Container(
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.yellow,
                      child: Text('使用 Expanded 包裹'),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 30.0,
              height: 30.0,
            ),

            Text('下面3个 Flexible的 flex  1:2:1'),
            Container(
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                      child: Container(
                        height: 30.0,
                        width: 30.0,
                        color: Colors.yellow,
                      )
                  ),
                  Flexible(
                      flex: 2,
                      child: Container(
                        height: 30.0,
                        width: 30.0,
                        color: Colors.green,
                      )
                  ),
                  Flexible(
                      flex: 1,
                      child: Container(
                        height: 30.0,
                        width: 30.0,
                        color: Colors.blue,
                      )
                  ),
                ],
              ),
            ),
            Container(
              width: 30.0,
              height: 30.0,
            ),
            Text('三个 Expanded 的 flex：1:2:1'),
            Container(
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      color: Colors.yellow,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      color: Colors.green,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 30.0,
              height: 30.0,
            ),
            Text('三个 Expanded 的 flex：1:1:1'),
            Container(
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      color: Colors.yellow,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      color: Colors.green,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}