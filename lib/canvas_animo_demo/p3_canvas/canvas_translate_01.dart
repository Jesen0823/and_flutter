import 'dart:async';
import 'dart:math';

import 'package:and_flutter/canvas_animo_demo/p2_paint/level4/paint_image_filter_matrix.dart';
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

  runApp(Paper15());
}

////////////////////////////////////////////
///  画布的变换是持久性的，变换之后所有的绘制会在变换后的画布上进行。
// 变换不是永久性的变换，需要使用状态的存储【save】和恢复【restore】回到之前的画布状态
/////////////////////////////////////////////
class Paper15 extends StatefulWidget {
  const Paper15({Key? key}) : super(key: key);

  @override
  State<Paper15> createState() => _Paper15State();
}

class _Paper15State extends State<Paper15> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper15Painter(),
      ),
    );
  }
}

class Paper15Painter extends CustomPainter {
  late Paint _paint;

  Paper15Painter(){
    _paint = Paint()..style = PaintingStyle.fill
      ..color = Color(0x33FF708E);
  }

  @override
  void paint(Canvas canvas, Size size) {

    canvas.translate(size.width / 2, size.height / 2);

    drawBackground(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void drawBackground(Canvas canvas) {
    canvas.drawCircle(Offset(0, 0), 50, _paint);

    canvas.drawPoints(
        ui.PointMode.points,
        [Offset(0, 0)],
        _paint
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth=5
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
}
