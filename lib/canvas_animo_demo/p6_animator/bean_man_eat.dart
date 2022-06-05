import 'dart:math';

import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter draw',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 58.0, left: 20),
              child: Center(
                child: Wrap(spacing: 20, runSpacing: 20, children: buildChildren()),
              ),
            )));
  }

  List<Widget> buildChildren() =>
      List<Widget>.generate(6,
              (index) => BeanMan(
            color: Colors.lightBlue,
            angle: (1 + index) * 6.0, // 背景
          ));
}
///////////////////////////////////////////////////////
class BeanMan extends StatefulWidget {

  final Color color;
  final double angle;

  const BeanMan({Key? key, this.color=Colors.lightBlueAccent, this.angle=30}) : super(key: key);

  @override
  State<BeanMan> createState() => _BeanManState();
}

class _BeanManState extends State<BeanMan> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(100,100),
      painter: BeanManPainter(color:widget.color,angle:widget.angle),
    );
  }
}

class BeanManPainter extends CustomPainter {
  final Color color; // 颜色
  final double angle;

  Paint _paint=Paint();

  BeanManPainter({this.color=Colors.blueAccent, this.angle=30}); // 角度(与x轴交角 角度制)

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    final double radius = size.width/2;
    canvas.translate(radius,size.height/2);

    _drawHead(canvas,size);
    _drawEye(canvas,radius);
  }

  //绘制头
  void _drawHead(Canvas canvas, Size size) {
    var rect = Rect.fromCenter(
        center: Offset(0, 0), height: size.width, width: size.height);
    var a = angle / 180 * pi;
    canvas.drawArc(rect, a, 2 * pi - a.abs() * 2, true, _paint..color = color);
  }

  //绘制眼睛
  void _drawEye(Canvas canvas, double radius) {
    canvas.drawCircle(Offset(radius * 0.15, -radius * 0.6), radius * 0.12,
        _paint..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant BeanManPainter oldDelegate) =>  oldDelegate.color != color || oldDelegate.angle != angle;
}
