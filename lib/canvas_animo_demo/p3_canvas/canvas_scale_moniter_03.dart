import 'dart:async';
import 'dart:math';

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

  runApp(Paper17());
}

////////////////////////////////////////////
///如果是相同或者对称的对象，可以通过缩放进行对称变化。
// 沿x轴镜像，就相当于canvas.scale(1, -1)；
// 沿y轴镜像，就相当于canvas.scale(-1, 1)；
// 沿原点镜像，就相当于canvas.scale(-1, -1)；
/////////////////////////////////////////////
class Paper17 extends StatefulWidget {
  const Paper17({Key? key}) : super(key: key);

  @override
  State<Paper17> createState() => _Paper17State();
}

class _Paper17State extends State<Paper17> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper17Painter(),
      ),
    );
  }
}

class Paper17Painter extends CustomPainter {
  late Paint _paint;
  final double recSize = 30; // 空格大小
  final double lineWidth = 1.0;
  final Color lineColor = Colors.grey;

  Paper17Painter() {
    _paint = Paint()..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..color = lineColor;;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    _drawGrid(canvas, size);

    _drawBackground(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void _drawBackground(Canvas canvas) {
    canvas.drawCircle(
        Offset(0, 0),
        50,
        _paint
          ..style = PaintingStyle.fill
          ..color = Color(0xDEFF708E));

    canvas.drawPoints(
        ui.PointMode.points,
        [Offset(0, 0)],
        _paint
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round);

    canvas.drawLine(
        Offset(20, 20),
        Offset(50, 50),
        _paint
          ..color = Colors.blueAccent
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke);
  }

  void _drawGrid(Canvas canvas, Size size) {

    _drawBottomRight(canvas, size);

    canvas.save();
    canvas.scale(1, -1); //沿x轴镜像
    _drawBottomRight(canvas, size);
    canvas.restore();

    canvas.save();
    canvas.scale(-1, 1); //沿y轴镜像
    _drawBottomRight(canvas, size);
    canvas.restore();

    /*canvas.save();
    canvas.scale(-1, -1); //沿原点镜像
    _drawBottomRight(canvas, size);
    canvas.restore();*/
  }

  void _drawBottomRight(Canvas canvas, Size size) {
    canvas.save();

    for (int i = 0; i < size.height / 2 / recSize; i++) {
      canvas.drawLine(Offset(0, 0), Offset(size.width / 2, 0), _paint);
      canvas.translate(0, recSize);
    }
    canvas.restore();

    canvas.save();
    for (int i = 0; i < size.width / 2 / recSize; i++) {
      canvas.drawLine(Offset(0, 0), Offset(0, size.height / 2), _paint);
      canvas.translate(recSize , 0);
    }
    canvas.restore();
  }
}
