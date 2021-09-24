import 'package:flutter/material.dart';

main() => runApp(new ContainerWidget());

class ContainerWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter容器 Container'),),
        body: Container(
          // 容器四周补白
          margin: EdgeInsets.only(left: 120.0, top: 50.0),
          // 卡片大小
          constraints: BoxConstraints.tightFor(width: 200.0,height: 150.0),
          decoration: BoxDecoration(
            gradient: RadialGradient(       // 背景径向渐变
              colors: [Colors.green, Colors.lightBlue],
              center: Alignment.topLeft,
              radius: .98
            ),
            boxShadow: [                    // 卡片阴影
              BoxShadow(
                color: Colors.black45,
                offset: Offset(2.0,2.0),
                blurRadius: 4.0
              )
            ]
          ),
          transform: Matrix4.rotationZ(.2),  //  卡片倾斜变换
          alignment: Alignment.center,       //   文字居中
          child: Text(
            "Hello Container",
            style: TextStyle(color: Colors.white, fontSize: 40.0),
          ),
        ),
      ),
    );
  }
}