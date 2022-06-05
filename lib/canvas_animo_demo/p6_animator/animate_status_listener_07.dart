import 'dart:math';

import 'package:and_flutter/canvas_animo_demo/p6_animator/bean_man_eat.dart';
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
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            body: Center(
              child: BeanMan(color: Colors.purpleAccent,),
            )));
  }
}
//////////////////////////////////////////////////////////

class BeanMan extends StatefulWidget {
  final Color color;

  const BeanMan({Key? key,  required this.color}) : super(key: key);

  @override
  State<BeanMan> createState() => _BeanManState();
}

class _BeanManState extends State<BeanMan> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ValueNotifier<Color> _color = ValueNotifier<Color>(Colors.blueAccent);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        lowerBound: 10,
        upperBound: 40,
        duration: const Duration(seconds: 1),
        vsync: this);

    _controller.addStatusListener(_statusListener);
    _controller.forward();
    _controller.repeat(reverse: true);
  }

  void _statusListener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
        _color.value = Colors.red;
        break;
      case AnimationStatus.forward:
        _color.value = Colors.green;
        break;
      case AnimationStatus.reverse:
        _color.value = Colors.cyan;
        break;
      case AnimationStatus.completed:
        _color.value = Colors.orangeAccent;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(100, 100),
      painter: BeanManPainter(
          color: _color,
          angle: _controller,
          repaint: Listenable.merge([_controller, _color])),
    );
  }
}

class BeanManPainter extends CustomPainter {
  final Animation<double> angle;
  final Listenable repaint;
  final ValueNotifier<Color> color;

  BeanManPainter(
      {required this.angle, required this.repaint, required this.color})
      : super(repaint: repaint);

  Paint _paint = Paint();

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
    canvas.drawArc(
        rect, a, 2 * pi - a.abs() * 2, true, _paint..color = color.value);
  }

  //绘制眼睛
  void _drawEye(Canvas canvas, double radius) {
    canvas.drawCircle(Offset(radius * 0.15, -radius * 0.6), radius * 0.12,
        _paint..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant BeanManPainter oldDelegate) =>
      oldDelegate.repaint != repaint;
}
