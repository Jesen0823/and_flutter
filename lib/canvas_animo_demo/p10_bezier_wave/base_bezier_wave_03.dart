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

  runApp(Paper03());
}

//// 二阶贝赛尔曲线波纹雏形
class Paper03 extends StatelessWidget {
  const Paper03({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper03Painter(),
      ),
    );
  }
}

class Paper03Painter extends CustomPainter {

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
  double wrapHeight =80;

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);
    canvas.translate(size.width/2, size.height/2);

    canvas.save();
    canvas.translate(-2*waveWidth, 0);
    _path.moveTo(0, 0);
    _path.relativeQuadraticBezierTo(waveWidth/2, -waveHeight, waveWidth, 0);
    _path.relativeQuadraticBezierTo(waveWidth/2, waveHeight, waveWidth, 0);
    _path.relativeQuadraticBezierTo(waveWidth/2, -waveHeight, waveWidth, 0);
    _path.relativeQuadraticBezierTo(waveWidth/2, waveHeight, waveWidth, 0);
    _path.relativeLineTo(0, wrapHeight);
    _path.relativeLineTo(-waveWidth*2*2.0,0);
    _path.close();
    canvas.drawPath(_path, _paint..style=PaintingStyle.fill);
    canvas.restore();

    _drawHelp(canvas);
  }

  void _drawHelp(Canvas canvas) {
    _helpPaint
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawRect(
        Rect.fromPoints(Offset(0,-wrapHeight), Offset(2*waveWidth,wrapHeight)),
        _helpPaint..strokeWidth=2);
}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>false;
}