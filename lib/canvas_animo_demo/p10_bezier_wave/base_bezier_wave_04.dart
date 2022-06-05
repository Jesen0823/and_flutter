import 'dart:ui';

import 'package:and_flutter/canvas_animo_demo/height_coordinate.dart';
import 'package:and_flutter/canvas_animo_demo/p8_path_curve/points_path_math_curve_draw_anim_04.dart';
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

  runApp(Paper04());
}

//// 二阶贝赛尔曲线波纹雏形
class Paper04 extends StatefulWidget {
  const Paper04({Key? key}) : super(key: key);

  @override
  State<Paper04> createState() => _Paper04State();
}

class _Paper04State extends State<Paper04> with SingleTickerProviderStateMixin {
  late AnimationController _controller;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
        vsync: this
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper04Painter(_controller),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


class Paper04Painter extends CustomPainter {

  final Animation<double> repaint;
  final BetterCoordinate coordinate = BetterCoordinate();

  Paint _helpPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
  ..color=Colors.purpleAccent;

  Path _path = Path();
  Path _path2 = Path();

  Paint _paint = Paint()
    ..color = Colors.orange;

  double waveWidth = 80;
  double waveHeight = 40;
  double wrapHeight =80;

  Paper04Painter(this.repaint):super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);
    canvas.translate(size.width/2, size.height/2);
    canvas.translate(0, -80);

    // 画布不剪裁
    canvas.save();
    canvas.translate(-2 * waveWidth + 2 * waveWidth * repaint.value, 0);
    _path.moveTo(0, 0);
    _path.relativeQuadraticBezierTo(
        waveWidth / 2, -waveHeight , waveWidth, 0);
    _path.relativeQuadraticBezierTo(waveWidth / 2, waveHeight , waveWidth, 0);
    _path.relativeQuadraticBezierTo(
        waveWidth / 2, -waveHeight , waveWidth, 0);
    _path.relativeQuadraticBezierTo(waveWidth / 2, waveHeight , waveWidth, 0);
    _path.relativeLineTo(0, wrapHeight);
    _path.relativeLineTo(-waveWidth * 2 * 2.0, 0);
    _path.close();
    canvas.drawPath(_path, _paint..style = PaintingStyle.fill);

    canvas.restore();
    _drawHelp(canvas);

    // 画布剪裁
    canvas.translate(0, 200);
    canvas.clipRect((Rect.fromCenter(
        center: Offset( waveWidth, 0),width: waveWidth*2,height: 200.0)));
    canvas.save();
    canvas.translate(-2 * waveWidth + 2 * waveWidth * repaint.value, 0);
    //_path.reset();
    _path2.moveTo(0, 0);
    _path2.relativeQuadraticBezierTo(
        waveWidth / 2, -waveHeight , waveWidth, 0);
    _path2.relativeQuadraticBezierTo(waveWidth / 2, waveHeight , waveWidth, 0);
    _path2.relativeQuadraticBezierTo(
        waveWidth / 2, -waveHeight , waveWidth, 0);
    _path2.relativeQuadraticBezierTo(waveWidth / 2, waveHeight , waveWidth, 0);
    _path2.relativeLineTo(0, wrapHeight);
    _path2.relativeLineTo(-waveWidth * 2 * 2.0, 0);
    _path2.close();
    canvas.drawPath(_path2, _paint..style = PaintingStyle.fill);

    canvas.restore();
    _drawHelp(canvas);
  }

  void _drawHelp(Canvas canvas) {
    _helpPaint
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawRect(
        Rect.fromPoints(
            Offset(0, -wrapHeight), Offset(2 * waveWidth, wrapHeight)),
        _helpPaint..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant Paper04Painter oldDelegate) =>oldDelegate.repaint!=repaint;
}