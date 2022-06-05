import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Chart04()),
      ),
    );
  }
}

/// 饼状图统计表
class Chart04 extends StatefulWidget {
  @override
  _Chart04State createState() => _Chart04State();
}

class _Chart04State extends State<Chart04> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Container(
        width: 400,
        height: 300,
        padding: EdgeInsets.only(top: 40, right: 20, bottom: 20, left: 20),
        child: CustomPaint(
          painter: ChartPainter(repaint: _controller),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          "月支出账单分布",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      )
    ]);
  }
}

const double _kScaleHeight = 8; // 刻度高
const double _kBarPadding = 10; // 柱状图前间隔
const double _kPiePadding = 20; // 饼状图边距

class ChartPainter extends CustomPainter {
  final TextPainter _textPainter =
      TextPainter(textDirection: TextDirection.ltr);

  final List<double> yData = [0.12, 0.25, 0.1, 0.18, 0.15, 0.2];
  final List<Color> colors = [
    Colors.red,
    Colors.orangeAccent,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.pink
  ].map((e) => e.withAlpha(100)).toList();

  final List<String> xData = ["学习资料", "伙食费", "话费", "游玩", "游戏", "其他"];

  final Animation<double> repaint;

  Path axisPath = Path();
  Paint axisPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  Paint gridPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.grey
    ..strokeWidth = 0.5;
  Paint fillPaint = Paint()..color = Colors.red;
  Paint linePaint = Paint()
    ..color = Colors.red
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  double radius = 0; // 饼图半径
  double yStep = 0; // y 间隔

  double maxData = 0; // 数据最大值

  final List<Offset> line = []; // 折线点位信息

  ChartPainter({required this.repaint}) : super(repaint: repaint) {
    maxData = yData.reduce(max);
  }

  @override
  void paint(Canvas canvas, Size size) {
    radius = size.shortestSide / 2 - _kPiePadding;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-pi / 2);

    Path clipPath = Path();
    clipPath.lineTo(radius, 0);
    clipPath.arcTo(
        Rect.fromCenter(
            center: Offset.zero, width: radius * 4, height: radius * 4),
        0,
        2 * pi * repaint.value,
        false);
    clipPath.close();
    if (repaint.value != 1.0) {
      canvas.clipPath(clipPath);
    }

    drawPieChart(canvas);
    drawInfo(canvas);
  }

  void drawInfo(Canvas canvas) {
    for (int i = 0; i < yData.length; i++) {
      Color color = colors[i % colors.length];

      canvas.save();
      canvas.rotate(2 * pi * yData[i] / 2);
      _drawAxisText(canvas, "${(yData[i] * 100).toStringAsFixed(1)}%",
          color: Colors.white,
          alignment: Alignment.center,
          offset: Offset(radius / 2 + 5, 0));

      Path showPath = Path();
      showPath.moveTo(radius, 0);
      showPath.relativeLineTo(15, 0);
      showPath.relativeLineTo(5, 10);
      canvas.drawPath(
        showPath,
        linePaint..color = color,
      );

      _drawAxisText(canvas, xData[i],
          color: color,
          fontSize: 9,
          alignment: Alignment.centerLeft,
          offset: Offset(radius + 5, 18));
      canvas.restore();

      canvas.rotate(2 * pi * yData[i]);
    }
  }

  void drawPieChart(Canvas canvas) {
    for (int i = 0; i < yData.length; i++) {
      Color color = colors[i % colors.length];
      Path path = Path();
      path.lineTo(radius, 0);
      path.arcTo(
          Rect.fromCenter(
              center: Offset.zero, width: radius * 2, height: radius * 2),
          0,
          2 * pi * yData[i],
          false);
      path.close();
      canvas.drawPath(
          path,
          fillPaint
            ..style = PaintingStyle.fill
            ..color = color);
      canvas.rotate(2 * pi * yData[i]);
    }
  }

  void drawLineChart(Canvas canvas) {
    canvas.drawPoints(PointMode.points, line, linePaint..strokeWidth = 5);

    Offset p1 = line[0];
    Path path = Path()..moveTo(p1.dx, p1.dy);
    for (var i = 1; i < line.length; i++) {
      path.lineTo(line[i].dx, line[i].dy);
    }
    linePaint..strokeWidth = 1;
    PathMetrics pms = path.computeMetrics();
    pms.forEach((pm) {
      canvas.drawPath(pm.extractPath(0, pm.length * repaint.value), linePaint);
    });
  }

  void drawYText(Canvas canvas, Size size) {
    canvas.save();
    double numStep = maxData / 5;
    for (int i = 0; i <= 5; i++) {
      if (i == 0) {
        _drawAxisText(canvas, '0', offset: Offset(-10, 2));
        canvas.translate(0, -yStep);
        continue;
      }

      canvas.drawLine(
          Offset(0, 0), Offset(size.width - _kScaleHeight, 0), gridPaint);

      canvas.drawLine(Offset(-_kScaleHeight, 0), Offset(0, 0), axisPaint);
      String str = '${(numStep * i).toStringAsFixed(0)}';
      _drawAxisText(canvas, str, offset: Offset(-10, 2));
      canvas.translate(0, -yStep);
    }
    canvas.restore();
  }

  void _drawAxisText(Canvas canvas, String str,
      {Color color = Colors.black,
      double fontSize = 11,
      bool x = false,
      Alignment alignment = Alignment.centerRight,
      Offset offset = Offset.zero}) {
    TextSpan text = TextSpan(
        text: str,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
        ));

    _textPainter.text = text;
    _textPainter.layout(); // 进行布局

    Size size = _textPainter.size;

    Offset offsetPos = Offset(-size.width / 2, -size.height / 2)
        .translate(-size.width / 2 * alignment.x + offset.dx, 0.0 + offset.dy);
    _textPainter.paint(canvas, offsetPos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
