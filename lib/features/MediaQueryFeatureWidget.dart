import 'package:flutter/material.dart';

/// MediaQuery Widget 的功能是查询⼀些数据，例如整个屏幕的宽 度、⾼度、设备像素⽐等数据
/// 在 Flutter 中获取 MediaQuery 的实例，⾸先 根Widget 必须 是 MaterialApp，然后在 MaterialApp 的 ⼦Widget ⾥运⾏：
/// MediaQuery.of(context); 返回的类型是 MediaQueryData
/// 要想获取 ⼦Widget 的宽⾼，就不能使⽤ MediaQuery.of(context) ,这个时候要⽤到 GlobalKey。 为 ⼦Widget 设置 GlobalKey，然后通过 GlobalKey 获取 ⼦ Widget 的宽⾼。

void main() => runApp(MediaQueryFeatureWidget());

GlobalKey _globalKey = GlobalKey();

class MediaQueryFeatureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(title: Text("Flutter 功能类Widget -- MediaQuery")),
          body: BodyWidget()),
    );
  }
}

class BodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "Hello Flutter",
          key: _globalKey,
        ),
        ElevatedButton(
          child: Text('getSize'),
          onPressed: () {
            //获取屏幕的宽高
            print("Screen width:" +
                MediaQuery.of(context).size.width.toString() +
                " Screen height:" +
                MediaQuery.of(context).size.height.toString());
            //获取子Widget 的宽高
            print("Text width:" +
                _globalKey.currentContext!.size!.width.toString() +
                " Screen height:" +
                _globalKey.currentContext!.size!.height.toString());
          },
        )
      ],
    );
  }
}
