import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

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

  runApp(Paper19());
}

////////////////////////////////////////////
/// 1. 点的三种绘制模式：
/// PointMode.points 只会绘制点 红色
/// PointMode.lines 只绘制相邻两个点之间的连线，奇数个点的情况下，最后一个点被忽略 紫色
/// PointMode.polygon 绘制所有点经过的路径或连一条线 绿色
///
/// 2. 点的两种绘制API:
/// canvas.drawPoints(..List<Offset>.)
/// canvas.drawRawPoints(..Float32List.)
/////////////////////////////////////////////
class Paper19 extends StatefulWidget {
  const Paper19({Key? key}) : super(key: key);

  @override
  State<Paper19> createState() => _Paper19State();
}

class _Paper19State extends State<Paper19> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper19Painter(),
      ),
    );
  }
}

class Paper19Painter extends CustomPainter {
  late Paint _gridPaint;
  late Paint _paint;
  final double recSize = 30; // 空格大小
  final double lineWidth = 1.0;
  final Color lineColor = Colors.grey;

  /// 以下两种集合都支持点的绘制
  /// canvas.drawPoints(..List<Offset>.)
  /// canvas.drawRawPoints(..Float32List.)
  final List<Offset> points = [
    Offset(-120, -30),
    Offset(-120, -120),
    Offset(-60, -60),
    Offset(0, -150),
    Offset(60, -60),
    Offset(120, -120),
    Offset(180, -150),
  ];
  final Float32List pointList = Float32List.fromList([
    -120,
    -30,
    -120,
    -120,
    -60,
    -60,
    0,
    -150,
    60,
    -60,
    120,
    -120,
    180,
    -150
  ]);

  Paper19Painter() {
    _gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..color = lineColor;
    ;

    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 8
      ..color = Colors.deepPurpleAccent;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    _drawGrid(canvas, size);

    _drawAxis(canvas, size);

    // 绘制点的三种模式
    _drawPointsWithPoints(canvas);
    _drawPointsWithLines(canvas);
    _drawPointLineWithPolygon(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

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

    canvas.save();
    canvas.scale(-1, -1); //沿原点镜像
    _drawBottomRight(canvas, size);
    canvas.restore();
  }

  void _drawBottomRight(Canvas canvas, Size size) {
    canvas.save();

    for (int i = 0; i < size.height / 2 / recSize; i++) {
      canvas.drawLine(Offset(0, 0), Offset(size.width / 2, 0), _gridPaint);
      canvas.translate(0, recSize);
    }
    canvas.restore();

    canvas.save();
    for (int i = 0; i < size.width / 2 / recSize; i++) {
      canvas.drawLine(Offset(0, 0), Offset(0, size.height / 2), _gridPaint);
      canvas.translate(recSize, 0);
    }
    canvas.restore();
  }

  /// 绘制坐标系
  void _drawAxis(Canvas canvas, Size size) {
    _paint
      ..color = Colors.blue
      ..strokeWidth = 1.5;
    canvas.drawLine(
        Offset(-size.width / 2, 0), Offset(size.width / 2, 0), _paint);
    canvas.drawLine(
        Offset(0, -size.height / 2), Offset(0, size.height / 2), _paint);
    canvas.drawLine(Offset(0, size.height / 2),
        Offset(0 - 7.0, size.height / 2 - 10), _paint);
    canvas.drawLine(Offset(0, size.height / 2),
        Offset(0 + 7.0, size.height / 2 - 10), _paint);
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2 - 10, 7), _paint);
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2 - 10, -7), _paint);
  }

  void _drawPointsWithPoints(Canvas canvas) {
    canvas.drawPoints(
        ui.PointMode.points,
        points,
        _paint
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round);
  }

  void _drawPointsWithLines(Canvas canvas) {
    canvas.save();
    canvas.translate(0, recSize);

    canvas.drawPoints(
        ui.PointMode.lines,
        points,
        _paint
          ..color = Colors.purple
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round);
    canvas.restore();
  }

  void _drawPointLineWithPolygon(Canvas canvas) {
    canvas.save();
    canvas.translate(0, recSize * 2);
    _paint
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(ui.PointMode.polygon, points, _paint);
    canvas.restore();
  }
}
