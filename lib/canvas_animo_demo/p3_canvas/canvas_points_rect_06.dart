import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:and_flutter/canvas_animo_demo/common_coordinate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(Paper20());
}

////////////////////////////////////////////
/// 矩形的绘制矩形裁剪
/////////////////////////////////////////////
class Paper20 extends StatefulWidget {
  const Paper20({Key? key}) : super(key: key);

  @override
  State<Paper20> createState() => _Paper20State();
}

class _Paper20State extends State<Paper20> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper20Painter(),
      ),
    );
  }
}

class Paper20Painter extends CustomPainter {
  final CommonCoordinate coordinate = CommonCoordinate();
  late Paint _paint;
  final double strokeWidth = 0.5;
  final Color color = Colors.blue;

  Paper20Painter() {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth
      ..color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制坐标系
    coordinate.paint(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);

    //_drawRect(canvas);

    //_drawRoundRect(canvas);

    _drawDRRect(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void _drawRect(Canvas canvas) {
    _paint
      ..color = Colors.blueAccent
      ..strokeWidth = 2;
    // 1. 矩形中心构造
    Rect rectFromCenter =
        Rect.fromCenter(center: Offset(0, 0), width: 160, height: 160);
    canvas.drawRect(rectFromCenter, _paint);
    // 2.矩形左上右下构造
    Rect rectLTRB = Rect.fromLTRB(-120, -120, -80, -80);
    canvas.drawRect(rectLTRB, _paint..color = Colors.deepPurpleAccent);

    // 3. 矩形左上宽高构造
    Rect rectLTWH = Rect.fromLTWH(80, -120, 40, 40);
    canvas.drawRect(rectLTWH, _paint..color = Colors.orange);

    // 4. 矩形内切圆构造
    Rect rectCircle = Rect.fromCircle(center: Offset(100, 100), radius: 20);
    canvas.drawRect(rectCircle, _paint..color = Colors.green);

    // 5. 矩形两点构造
    Rect rectFromPoints = Rect.fromPoints(Offset(-120, 80), Offset(-80, 120));
    canvas.drawRect(rectFromPoints, _paint..color = Colors.pinkAccent);
  }

  // 绘制圆角矩形
  void _drawRoundRect(Canvas canvas) {
    _paint
      ..color = Colors.brown
      ..strokeWidth = 1.5;

    // fromRectXY
    Rect rectCenter = Rect.fromCenter(center: Offset(0,0), width: 160, height: 160);
    RRect rRect = RRect.fromRectXY(rectCenter, 10, 10);
    canvas.drawRRect(rRect, _paint);

    // fromLTRBXY
    RRect rRectLTRBXY = RRect.fromLTRBXY(-120, -120, -80, -80, 10, 10);
    canvas.drawRRect(rRectLTRBXY, _paint..color=Colors.green);

    // 圆角矩形fromLTRBR构造
    RRect rRectLTRBR = RRect.fromLTRBR(80, -120, 120, -80, Radius.circular(10));
    canvas.drawRRect(rRectLTRBR,
        _paint..color = Colors.orange);

    // 圆角矩形fromLTRBAndCorners构造
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(80, 80, 120, 120,
            bottomRight: Radius.elliptical(10, 10)),
        _paint..color = Colors.green);

    //. 矩形两点构造
    Rect rectFromPoints = Rect.fromPoints(Offset(-120, 80), Offset(-80, 120));
    canvas.drawRRect(
        RRect.fromRectAndCorners(rectFromPoints,
            bottomLeft: Radius.elliptical(10, 10)),
        _paint..color = Colors.purple);
  }

  void _drawDRRect(Canvas canvas) {
    _paint
      ..color = Colors.blue
      ..strokeWidth = 1.5;
    Rect outRect =
    Rect.fromCenter(center: Offset(0, 0), width: 160, height: 160);
    Rect inRect =
    Rect.fromCenter(center: Offset(0, 0), width: 100, height: 100);
    canvas.drawDRRect(RRect.fromRectXY(outRect, 20, 20),
        RRect.fromRectXY(inRect, 20, 20), _paint);

    Rect outRect2 =
    Rect.fromCenter(center: Offset(0, 0), width: 60, height: 60);
    Rect inRect2 =
    Rect.fromCenter(center: Offset(0, 0), width: 40, height: 40);
    canvas.drawDRRect(RRect.fromRectXY(outRect2, 15, 15),
        RRect.fromRectXY(inRect2, 10, 10), _paint..color=Colors.green);
  }
}
