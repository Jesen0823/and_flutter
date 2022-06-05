import 'dart:ui';

import 'package:and_flutter/canvas_animo_demo/height_coordinate.dart';
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

  runApp(Paper01());
}

/// 简单二次贝塞尔曲线
class Paper01 extends StatelessWidget {
  const Paper01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper01Painter(),
      ),
    );
  }
}

class Paper01Painter extends CustomPainter {
  final BetterCoordinate coordinate = BetterCoordinate();

  Offset p1 = Offset(100, 100);
  Offset p2 = Offset(120, -60);

  late Paint _paint;
  late Path _path;

  Paint _helpPaint = Paint();

  Paper01Painter() : super() {
    _paint = Paint()
      ..color = Colors.pinkAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    _path = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);
    _path.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
    canvas.drawPath(_path, _paint);

    _drawHelp(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void _drawHelp(Canvas canvas) {
    _helpPaint
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(PointMode.lines, [Offset.zero, p1,p1, p2],
        _helpPaint..strokeWidth = 1);
    canvas.drawPoints(PointMode.points, [Offset.zero, p1, p2],
        _helpPaint..strokeWidth = 8);
  }
}
