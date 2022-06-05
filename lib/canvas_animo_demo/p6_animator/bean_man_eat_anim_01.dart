import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(MyApp());
}

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

  List<Widget> buildChildren() => List<Widget>.generate(
      6,
      (index) => BeanMan01(
            color: Colors.lightBlue,
            angle: (1 + index) * 6.0, // 背景
          ));
}

///////////////////////////////////////////////////////
class BeanMan01 extends StatefulWidget {
  final Color color;
  final double angle;

  const BeanMan01(
      {Key? key, this.color = Colors.lightBlueAccent, this.angle = 30})
      : super(key: key);

  @override
  State<BeanMan01> createState() => _BeanMan01State();
}

class _BeanMan01State extends State<BeanMan01>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        lowerBound: 10,
        upperBound: 40,
        duration: const Duration(seconds: 1),
        vsync: this)
      ..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(100, 100),
      painter: BeanMan01Painter(color: widget.color, angle: _controller),
    );
  }
}

class BeanMan01Painter extends CustomPainter {
  final Color color; // 颜色
  final Animation<double> angle;

  Paint _paint = Paint();

  BeanMan01Painter({this.color = Colors.blueAccent, required this.angle})
      : super(repaint: angle); // 角度(与x轴交角 角度制)

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    final double radius = size.width / 2;
    canvas.translate(radius, size.height / 2);

    _drawHead(canvas, size);
    _drawEye(canvas, radius);
  }

  //绘制头
  void _drawHead(Canvas canvas, Size size) {
    var rect = Rect.fromCenter(
        center: Offset(0, 0), height: size.width, width: size.height);
    var a = angle.value / 180 * pi;
    canvas.drawArc(rect, a, 2 * pi - a.abs() * 2, true, _paint..color = color);
  }

  //绘制眼睛
  void _drawEye(Canvas canvas, double radius) {
    canvas.drawCircle(Offset(radius * 0.15, -radius * 0.6), radius * 0.12,
        _paint..color = Colors.white);
  }

  /// CustomPainter 中有一个 _repaint 的 Listenable 对象。
  /// 这个对象发出通知时，在 shouldRepaint 允许时会触发重绘，这是触发重绘的最高效的方式
  @override
  bool shouldRepaint(covariant BeanMan01Painter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.angle != angle;
}
