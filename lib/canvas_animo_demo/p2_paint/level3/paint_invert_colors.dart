import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

/// 画笔是否反色 invertColors 即色彩取反
void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(Paper9());
}

class Paper9 extends StatefulWidget {
  @override
  _PaperState createState() => _PaperState();
}

class _PaperState extends State<Paper9> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  CustomPaint(
      painter: Paper9Painter(),
    );
  }
}

class Paper9Painter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    drawInvertColors(canvas);
  }
  void drawInvertColors(Canvas canvas) {
    var paint = Paint();
    paint..color = Color(0xff009A44);
    canvas.drawCircle(Offset(100, 100), 50, paint..invertColors = false);
    canvas.drawCircle(Offset(100+120.0, 100), 50, paint..invertColors = true);
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}