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

  runApp(Paper21());
}

////////////////////////////////////////////
/// 圆形椭圆 的绘制矩形裁剪
/////////////////////////////////////////////
class Paper21 extends StatefulWidget {
  const Paper21({Key? key}) : super(key: key);

  @override
  State<Paper21> createState() => _Paper21State();
}

class _Paper21State extends State<Paper21> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper21Painter(),
      ),
    );
  }
}

class Paper21Painter extends CustomPainter {
  final CommonCoordinate coordinate = CommonCoordinate();
  late Paint _paint;
  final double strokeWidth = 0.5;
  final Color color = Colors.blue;

  Paper21Painter() {
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

    canvas.save();
    canvas.translate(-200, 0);
    canvas.drawCircle(Offset(0, 0), 60, _paint..color = Color(0xAA2222ff));
    canvas.restore();

    // 椭圆
    var rectOval =
        Rect.fromCenter(center: Offset(0, 0), height: 80, width: 120);
    canvas.drawOval(rectOval, _paint..color = Color(0xAAEE55BB));

    // 曲线
    canvas.save();
    canvas.translate(200, 0);
    canvas.drawOval(
        rectOval,
        _paint
          ..color = Color(0xAAEE55BB)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    canvas.drawArc(
        rectOval,
        pi / 4,
        2 * pi / 3,
        false,
        _paint
          ..color = Color(0xAA88DD66)
          ..style = PaintingStyle.fill);

    var rectOval2 =
    Rect.fromCenter(center: Offset(0, 0), height: 100, width: 140);
    canvas.drawArc(
        rectOval2,
        pi / 4,
        2 * pi / 3,
        true,// 曲线要合并
        _paint
          ..color = Color(0xDDAA99FF)
          ..style = PaintingStyle.stroke);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
