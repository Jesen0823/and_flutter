import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

/// Shader之 扫描渐变着色器
void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(Paper6());
}

class Paper6 extends StatefulWidget {
  const Paper6({Key? key}) : super(key: key);

  @override
  State<Paper6> createState() => _Paper6State();
}

class _Paper6State extends State<Paper6> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Paper6Painter(),
    );
  }

  @override
  void initState() {
    //横屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    //全屏显示
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }
}

class Paper6Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    drawShaderSweep(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void drawShaderSweep(Canvas canvas) {
    var colors = [
      Color(0xFFF60C0C),
      Color(0xFFF3B913),
      Color(0xFFE7F716),
      Color(0xFF3DF30B),
      Color(0xFF0DF6EF),
      Color(0xFF08AbDB),
      Color(0xFFB709F4),
    ];

    var pos = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];

    Paint paint = Paint();
    paint
      ..style = PaintingStyle.fill
      ..color = Colors.lightBlue;

    paint.shader = ui.Gradient.sweep(
        Offset(80 + 120 * 0, 80), colors, pos, TileMode.clamp, pi / 2, pi);
    canvas.drawCircle(Offset(80 + 120 * 0, 80), 60, paint);

    paint.shader = ui.Gradient.sweep(
        Offset(80 + 120 * 1, 80), colors, pos, TileMode.repeated, pi / 2, pi);
    canvas.drawCircle(Offset(80 + 120 * 1, 80), 60, paint);

    paint.shader = ui.Gradient.sweep(
        Offset(80 + 120 * 2, 80), colors, pos, TileMode.mirror, pi / 2, pi);
    canvas.drawCircle(Offset(80 + 120 * 2, 80), 60, paint);

    paint.shader = ui.Gradient.sweep(
        Offset(80 + 120 * 3, 80), colors, pos, TileMode.clamp);
    canvas.drawCircle(Offset(80 + 120 * 3, 80), 60, paint);
  }
}
