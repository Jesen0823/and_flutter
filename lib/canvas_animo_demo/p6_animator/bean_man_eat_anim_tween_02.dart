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
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

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
          child: BeanMan02(),
        )));
  }
}

///////////////////////////////////////////////////////
class BeanMan02 extends StatefulWidget {
  final Color color;

  BeanMan02({Key? key, this.color = Colors.lightBlue}) : super(key: key);

  @override
  _BeanMan02State createState() => _BeanMan02State();
}

class _BeanMan02State extends State<BeanMan02> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorCtrl;
  late Animation<double> _angleCtrl;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _angleCtrl = _controller.drive(Tween(begin: 10, end: 40));

    _colorCtrl =
        ColorTween(begin: Colors.green, end: Colors.amber).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(100, 100),
      painter: BeanMan02Painter(
          color: _colorCtrl, angle: _angleCtrl, repaint: _controller),
    );
  }
}

class BeanMan02Painter extends CustomPainter {
  final Animation<double> repaint;
  final Animation<double> angle;
  final Animation<Color?> color;

  Paint _paint = Paint();

  BeanMan02Painter({ required this.repaint,required this.color,required this.angle})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size); //剪切画布
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
    canvas.drawArc(
        rect, a, 2 * pi - a.abs() * 2, true, _paint..color = color.value??Colors.black);
  }

  //绘制眼睛
  void _drawEye(Canvas canvas, double radius) {
    canvas.drawCircle(Offset(radius * 0.15, -radius * 0.6), radius * 0.12,
        _paint..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant BeanMan02Painter oldDelegate)=> oldDelegate.repaint != repaint;
}