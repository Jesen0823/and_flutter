import 'dart:math';

import 'package:flutter/cupertino.dart';
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
          child: CurveBox(
            color: Colors.blue,
            curve: Cubic(1, -0.06, 0.1, 1.2),
          ),
        )));
  }
}

/// 动画曲线的核心是四个数字，它的本身是一个贝塞尔曲线。
/// 起止点固定，也就是说动画曲线在形式上的表现就是两个控制点。Flutter 中使用 Curve 类来表述。
/// Curve 是一个抽象类，它有很多实现子类。最通用的是 Cubic ，传入四个值。
/// 下面来看一下，如何使用 CurveTween 让动画的变化速率具有曲线效果。
/// Curve --- 抽象类
// 	|--- Cubic 四值三阶贝塞尔曲线
// 	|--- FlippedCurve  翻转曲线
// 	|--- SawTooth 锯齿形曲线
// 	|--- Threshold 0~阈值 曲线
// 	|--- ...

class CurveBox extends StatefulWidget {
  final Color color;
  final Curve curve;

  const CurveBox({Key? key, required this.color, required this.curve})
      : super(key: key);

  @override
  State<CurveBox> createState() => _CurveBoxState();
}

class _CurveBoxState extends State<CurveBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _angleAnim;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _angleAnim = CurveTween(curve: widget.curve).animate(_controller);
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(100, 100),
      painter: CurveBoxPainter(_controller, _angleAnim),
    );
  }
}

class CurveBoxPainter extends CustomPainter {
  final Animation<double> repaint;
  Animation<double> angleAnimation;

  Paint _paint = Paint();

  CurveBoxPainter(this.repaint, this.angleAnimation) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.translate(size.width / 2, size.height / 2);
    _drawRing(canvas, size);
    _drawRedCircle(canvas, size);
    _drawGreenCircle(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CurveBoxPainter oldDelegate) =>
      oldDelegate.repaint != repaint;

  void _drawRing(Canvas canvas, Size size) {
    _paint
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawCircle(Offset.zero, size.width / 2 - 5, _paint);
  }

  void _drawRedCircle(Canvas canvas, Size size) {
    canvas.save();
    canvas.rotate(angleAnimation.value * 2 * pi);
    _paint
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset.zero.translate(0, -(size.width / 2 - 5)), 5, _paint);
    canvas.restore();
  }

  void _drawGreenCircle(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(0, angleAnimation.value * (size.height - 10));
    _paint
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset.zero.translate(0, -(size.width / 2 - 5)), 5, _paint);
    canvas.restore();
  }
}
