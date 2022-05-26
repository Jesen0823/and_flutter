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

  runApp(Paper16());
}

////////////////////////////////////////////
/// 画布变换之后，如果不做处理，之后所有的操作都会在变化后画布的基础上进行。
// 当使用 canvas.save() 时，当前画布的状态就会被保存，当执行 canvas.restore() 时，画布就会回到上次保存的状态。
// 比如：在上面画横线前save画布这时画布的[顶点在屏幕中心]，画横线的过程中画布的顶点被[下移到了最后]。
// 画完后restore画布，就能让画布顶点重新回到[屏幕中心]。
/////////////////////////////////////////////
class Paper16 extends StatefulWidget {
  const Paper16({Key? key}) : super(key: key);

  @override
  State<Paper16> createState() => _Paper16State();
}

class _Paper16State extends State<Paper16> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper16Painter(),
      ),
    );
  }
}

class Paper16Painter extends CustomPainter {
  late Paint _paint;
  final double recSize = 30; // 空格大小
  final double lineWidth = 1.0;
  final Color lineColor = Colors.grey;

  Paper16Painter() {
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

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
