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

//// 二阶贝赛尔曲线波纹雏形
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
  Paint _helpPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
  ..color=Colors.purpleAccent;

  Path _path = Path();

  Paint _paint = Paint()
    ..color = Colors.orange;
  double waveWidth = 80;
  double waveHeight = 40;

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);
    canvas.translate(size.width/2, size.height/2);

    _path.relativeQuadraticBezierTo(waveWidth/2,-waveHeight,waveWidth,0);
    canvas.drawPath(_path, _paint..style=PaintingStyle.stroke..strokeWidth=2);
    _drawHelp(canvas);

    canvas.translate(0, 60);
    canvas.drawPath(_path, _paint..style=PaintingStyle.fill..color=Colors.orangeAccent);
    _drawHelp(canvas);

    canvas.translate(0, 60);
    _path.reset();
    _path.relativeQuadraticBezierTo( waveWidth / 2, -waveHeight, waveWidth, 0);
    _path.relativeQuadraticBezierTo( waveWidth / 2, -waveHeight, waveWidth, 0);
    canvas.drawPath(_path, _paint..style=PaintingStyle.fill..color=Colors.deepOrangeAccent);
    _drawHelp(canvas);

    canvas.translate(0, 60);
    _path.reset();
    _path.relativeQuadraticBezierTo( waveWidth / 2, -waveHeight, waveWidth, 0);
    _path.relativeQuadraticBezierTo( waveWidth / 2, waveHeight, waveWidth, 0);
    canvas.drawPath(_path, _paint..style=PaintingStyle.fill..color=Colors.deepPurpleAccent);
    _drawHelp(canvas);
  }

  void _drawHelp(Canvas canvas) {
    _helpPaint
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Offset p1 = Offset(waveWidth/2, -waveHeight);
    Offset p2 = Offset(waveWidth, 0);
    canvas.drawPoints(PointMode.lines, [Offset.zero, p1,p1, p2],
        _helpPaint..strokeWidth = 1);
    canvas.drawPoints(PointMode.points, [Offset.zero, p1, p2],
        _helpPaint..strokeWidth = 8);
}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>false;
}