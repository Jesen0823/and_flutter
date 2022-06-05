import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(Paper05());
}
/// 波纹成型

class Paper05 extends StatefulWidget {
  @override
  _Paper05State createState() => _Paper05State();
}

class _Paper05State extends State<Paper05> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..repeat()
    ;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper05Painter(
            CurveTween(curve: Curves.linear).animate(_controller)),
      ),
    );
  }
}

class Paper05Painter extends CustomPainter {

  final Animation<double> repaint;

  Paper05Painter(this.repaint) : super(repaint: repaint);

  double waveWidth = 80;
  double wrapHeight = 100;
  double waveHeight = 10;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);


    /// 矩形
    canvas.save();
    canvas.translate(-400, 0);
    canvas.clipRect((Rect.fromCenter(
        center: Offset(waveWidth, 0), width: waveWidth * 2, height: 200.0)));

    Paint paint1 = Paint();

    Path path1  = getWavePath();
    canvas.translate(-4 * waveWidth + 2 * waveWidth * repaint.value, 0);
    canvas.drawPath(path1, paint1..color = Colors.orange);

    canvas.translate(2*waveWidth* repaint.value, 0);
    canvas.drawPath(path1, paint1..color = Colors.orange.withAlpha(88));
    canvas.restore();

    /// 圆形
    canvas.save();
    canvas.translate(-200, 0);
    canvas.clipPath(Path()
      ..addOval(Rect.fromCenter(
          center: Offset( waveWidth, 0),width: waveWidth*2,height: waveWidth*2)));
    Paint paint2 = Paint();

    Path path2  = getWavePath();
    canvas.translate(-4 * waveWidth + 2 * waveWidth * repaint.value, 0);
    canvas.drawPath(path2, paint2..color = Colors.green);

    canvas.translate(2*waveWidth* repaint.value, 0);
    canvas.drawPath(path2, paint2..color = Colors.green.withAlpha(88));
    canvas.restore();

    /// 椭圆
    canvas.save();
    canvas.translate(0, 0);
    canvas.clipPath(Path()
      ..addOval(Rect.fromCenter(
          center: Offset( waveWidth, 0),
          width: waveWidth*2,height: 200.0)));
    Paint paint3 = Paint();

    Path path3  = getWavePath();
    canvas.translate(-4 * waveWidth + 2 * waveWidth * repaint.value, 0);
    canvas.drawPath(path3, paint3..color = Colors.lightBlue);

    canvas.translate(2*waveWidth* repaint.value, 0);
    canvas.drawPath(path3, paint3..color = Colors.lightBlue.withAlpha(88));
    canvas.restore();

    /// 圆角矩形
    canvas.save();
    canvas.translate(200, 0);
    canvas.clipPath(Path()
      ..addRRect(RRect.fromRectXY(Rect.fromCenter(
          center: Offset( waveWidth, 0),
          width: waveWidth*2,height: 200.0), 30 , 30)));
    Paint paint4 = Paint();

    Path path4  = getWavePath();
    canvas.translate(-4 * waveWidth + 2 * waveWidth * repaint.value, 0);
    canvas.drawPath(path4, paint4..color = Colors.redAccent);

    canvas.translate(2*waveWidth* repaint.value, 0);
    canvas.drawPath(path4, paint4..color = Colors.redAccent.withAlpha(88));
    canvas.restore();
  }

  Path getWavePath() {
    Path path = Path();
    path.relativeQuadraticBezierTo(
        waveWidth / 2, -waveHeight * 2, waveWidth, 0);
    path.relativeQuadraticBezierTo(
        waveWidth / 2, waveHeight * 2, waveWidth, 0);
    path.relativeQuadraticBezierTo(
        waveWidth / 2, -waveHeight * 2, waveWidth, 0);
    path.relativeQuadraticBezierTo(
        waveWidth / 2, waveHeight * 2, waveWidth, 0);
    path.relativeQuadraticBezierTo(
        waveWidth / 2, -waveHeight * 2, waveWidth, 0);
    path.relativeQuadraticBezierTo(
        waveWidth / 2, waveHeight * 2, waveWidth, 0);
    path.relativeLineTo(0, wrapHeight);
    path.relativeLineTo(-waveWidth * 3 * 2.0, 0);
    return path;
  }

  @override
  bool shouldRepaint(Paper05Painter oldDelegate) =>
      oldDelegate.repaint != repaint;
}