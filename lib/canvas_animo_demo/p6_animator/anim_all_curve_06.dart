import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Flutter内置的曲线效果
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
  final curvesMap = {
    "linear": Curves.linear,
    "decelerate": Curves.decelerate,
    "fastLinearToSlowEaseIn": Curves.fastLinearToSlowEaseIn,
    "ease": Curves.ease,
    "easeIn": Curves.easeIn,
    "easeInToLinear": Curves.easeInToLinear,
    "easeInSine": Curves.easeInSine,
    "easeInQuad": Curves.easeInCubic,
    "easeInCubic": Curves.easeInCubic,
    "easeInQuart": Curves.easeInQuart,
    "easeInQuint": Curves.easeInQuint,
    "easeInExpo": Curves.easeInExpo,
    "easeInCirc": Curves.easeInCirc,
    "easeInBack": Curves.easeInBack,
    "easeOut": Curves.easeOut,
    "linearToEaseOut": Curves.linearToEaseOut,
    "easeOutSine": Curves.easeOutSine,
    "easeOutQuad": Curves.easeOutQuad,
    "easeOutCubic": Curves.easeOutCubic,
    "easeOutQuart": Curves.easeOutQuart,
    "easeOutQuint": Curves.easeOutQuint,

    // "easeOutExpo": Curves.easeOutExpo,
    // "easeOutCirc": Curves.easeOutCirc,
    // "easeOutBack": Curves.easeOutBack,
    // "easeInOut": Curves.easeInOut,
    // "easeInOutSine": Curves.easeInOutSine,
    // "easeInOutQuad": Curves.easeInOutQuad,
    // "easeInOutCubic": Curves.easeInOutCubic,
    // "easeInOutQuart": Curves.easeInOutQuart,
    // "easeInOutQuint": Curves.easeInOutQuint,
    // "easeInOutExpo": Curves.easeInOutExpo,
    // "easeInOutCirc": Curves.easeInOutCirc,
    // "easeInOutBack": Curves.easeInOutBack,
    // "fastOutSlowIn": Curves.fastOutSlowIn,
    // "slowMiddle": Curves.slowMiddle,
    // "bounceIn": Curves.bounceIn,
    // "bounceOut": Curves.bounceOut,
    // "bounceInOut": Curves.bounceInOut,
    // "elasticIn": Curves.elasticIn,
    // "elasticInOut": Curves.elasticInOut,
    // "elasticOut": Curves.elasticOut,
  };

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
                child: Wrap(
                  runSpacing: 10,
                  children: curvesMap.keys
                      .map((e) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CurveBox2(
                                curve: curvesMap[e]!,
                                color: Colors.red,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                e,
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ))
                      .toList(),
                ))));
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

class CurveBox2 extends StatefulWidget {
  final Color color;
  final Curve curve;

  const CurveBox2({Key? key, required this.color, required this.curve})
      : super(key: key);

  @override
  State<CurveBox2> createState() => _CurveBox2State();
}

class _CurveBox2State extends State<CurveBox2>
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
      painter: CurveBox2Painter(_controller, _angleAnim),
    );
  }
}

class CurveBox2Painter extends CustomPainter {
  final Animation<double> repaint;
  Animation<double> angleAnimation;

  Paint _paint = Paint();

  CurveBox2Painter(this.repaint, this.angleAnimation) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.translate(size.width / 2, size.height / 2);
    _drawRing(canvas, size);
    _drawRedCircle(canvas, size);
    _drawGreenCircle(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CurveBox2Painter oldDelegate) =>
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
