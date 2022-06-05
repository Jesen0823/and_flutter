import 'dart:math';
import 'dart:ui' as ui;

import 'package:and_flutter/canvas_animo_demo/p5_color/color_draw_image_03.dart';
import 'package:flutter/material.dart';
import 'package:and_flutter/canvas_animo_demo/common_coordinate.dart';
import 'package:flutter/services.dart';

import '../height_coordinate.dart';

/// 绘制数学函数曲线
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
      duration: const Duration(seconds: 15),
        vsync: this
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        // 使用CustomPaint
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


const List<Color> colors = [
  Color(0xFFF60C0C),
  Color(0xFFF3B913),
  Color(0xFFE7F716),
  Color(0xFF3DF30B),
  Color(0xFF0DF6EF),
  Color(0xFF0829FB),
  Color(0xFFB709F4),
];
const List<double> pos = [
  1.0 / 7,
  2.0 / 7,
  3.0 / 7,
  4.0 / 7,
  5.0 / 7,
  6.0 / 7,
  1.0
];

class Paper04Painter extends CustomPainter {
  final BetterCoordinate coordinate =
      BetterCoordinate(gridColor: Colors.grey.withAlpha(100));
  final List<Offset> points = [];

  late Paint _paint;
  late Paint _pointPaint;
  late Path _path;

  final Animation<double> repaint;

  Paper04Painter(this.repaint) : super(repaint: repaint) {
    _paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    _pointPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    _path = Path();

    _paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(100, 0), colors, pos, TileMode.mirror);

    //initPoints();
    initPointsWithPolar();
  }

  // 普通函数初始化
  void initPoints() {
    final double step = 8;
    final double min = -360;
    final double max = 360;
    for (double x = min; x <= max; x += step) {
      points.add(Offset(x, f1(x)));
    }
    points.add(Offset(max, f1(max)));
    points.add(Offset(max, f1(max)));
  }

  /// 极坐标表示的函数
  void initPointsWithPolar() {
    final double step = 4;
    final double min = 0;
    final double max = 360;
    for (double x = min; x < max; x += step) {
      double thta = (pi / 180 * x); // 角度转弧度
      var p = f4(thta);
      points.add(Offset(p * cos(thta), p * sin(thta)));
    }
    double thta = (pi / 180 * max);
    points.add(Offset(f4(thta) * cos(thta), f4(thta) * sin(thta)));
    points.add(Offset(f4(thta) * cos(thta), f4(thta) * sin(thta)));
  }

  /// 函数 y = -x²/200 + 100
  double f1(double x) {
    double y = -x * x / 200 + 100;
    return y;
  }

  /// 函数 ρ = 10 * θ
  double f2(double thta) {
    double p = 10 * thta;
    return p;
  }

  /// 函数 ρ = 100*(1-cosθ)
  double f3(double thta) {
    double p = 100 * (1 - cos(thta));
    return p;
  }

  /// 函数 ρ = 150*|sin(5*θ)|
  double f4(double thta) {
    double p = 150 * sin(5 * thta).abs();
    return p;
  }

  /// 函数 ρ=(e^(cosθ)- 2cos(4θ) + [sin(θ/12)]^5)*100
  double f5(double thta) {
    double p =
        50 * (pow(e, cos(thta)) - 2 * cos(4 * thta) + pow(sin(thta / 12), 5));
    return p;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //coordinate.paint(canvas, size);
    canvas.translate(size.width / 2, size.height / 2);

    Offset p1 = points[0];
    _path.reset();
    _path..moveTo(p1.dx, p1.dy);

    for (int i = 1; i < points.length - 1; i++) {
      double xc = (points[i].dx + points[i + 1].dx) / 2;
      double yc = (points[i].dy + points[i + 1].dy) / 2;
      Offset p2 = points[i];
      _path.quadraticBezierTo(p2.dx, p2.dy, xc, yc);
    }

    // 这里不用绘制，下面动态绘制
    //canvas.drawPath(_path, _paint);

    ui.PathMetrics pms = _path.computeMetrics();
    pms.forEach((element) {
      ui.Tangent? tangent =
          element.getTangentForOffset(element.length * repaint.value);
      if (tangent == null) return;
      // 动态画路径
      canvas.drawPath(element.extractPath(0, element.length*repaint.value),_paint);
      canvas.drawCircle(tangent.position, 4, _pointPaint..color = Colors.lightBlueAccent);
    });

    /*canvas.translate(0, 40);
    canvas.drawPoints(ui.PointMode.points, points, _paint);*/
  }

  @override
  bool shouldRepaint(covariant Paper04Painter oldDelegate) =>
      oldDelegate.repaint != repaint;
}
