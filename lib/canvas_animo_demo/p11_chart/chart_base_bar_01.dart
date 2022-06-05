import 'dart:math';

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
        body: Center(child: Chart01()),
      ),
    );
  }
}

class Chart01 extends StatelessWidget {
  const Chart01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: 350,
          height: 250,
          padding: EdgeInsets.only(top: 40, right: 20, bottom: 20, left: 20),
          child: CustomPaint(
            painter: Chart01Painter(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "下半年销售利润概览",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

// 刻度高
const double scaleHeight = 8;
// 柱状图间距
const double barPading = 10;

class Chart01Painter extends CustomPainter {
  final TextPainter _textPainter =
      TextPainter(textDirection: TextDirection.ltr);
  final List<double> yData = [88, 60, 78, 87, 90, 86];
  final List<String> xData = ["7月", "8月", "9月", "10月", "11月", "12月"];

  Path axisPath = Path();
  Paint axisPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  Paint gridPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.grey
    ..strokeWidth = 0.5;

  Paint fillPaint = Paint()..color = Colors.orangeAccent;

  double xStep = 0;
  double yStep = 0;
  double maxData = 0;

  Paint _helpPaint = Paint();

  Chart01Painter() {
    maxData = yData.reduce(max);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 辅助绘制，用于观察画布大小和最初的原点，左上角
    canvas.drawRect(
        Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
        _helpPaint
          ..style = PaintingStyle.fill
          ..color = Colors.red.withAlpha(30));
    _drawHelpPoint(canvas, Colors.redAccent);
    // 向Y轴正方形移动画布高度
    canvas.translate(0, size.height);
    // 绘制移动后的原点变化
    _drawHelpPoint(canvas, Colors.deepOrangeAccent);
    // 向x,y轴移动一个刻度
    canvas.translate(scaleHeight, -scaleHeight);
    _drawHelpPoint(canvas, Colors.orangeAccent);
    // 开始绘制坐标系
    axisPath.moveTo(-scaleHeight, 0);
    axisPath.relativeLineTo(size.width, 0);
    axisPath.moveTo(0, scaleHeight);
    axisPath.relativeLineTo(0, -size.height);
    canvas.drawPath(axisPath, axisPaint);

    drawYText(canvas, size);
    drawXText(canvas, size);
    drawBarChart(canvas, size);
  }

  void _drawHelpPoint(Canvas canvas, Color color) {
    canvas.drawCircle(Offset.zero, 4, _helpPaint..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void drawYText(Canvas canvas, Size size) {
    canvas.save();
    yStep = (size.height - scaleHeight) / 5;
    double numStep = maxData / 5;
    for (int i = 0; i <= 5; i++) {
      if (i == 0) {
        _drawAxisText(canvas, '0', offset: Offset(-10, 2));
        canvas.translate(0, -yStep);
        continue;
      }

      canvas.drawLine(
          Offset(0, 0), Offset(size.width - scaleHeight, 0), gridPaint);

      canvas.drawLine(Offset(-scaleHeight, 0), Offset(0, 0), axisPaint);
      String str = '${(numStep * i).toStringAsFixed(0)}';
      _drawAxisText(canvas, str, offset: Offset(-10, 2));
      canvas.translate(0, -yStep);
    }
    canvas.restore();
  }

  void drawXText(Canvas canvas, Size size) {
    xStep = (size.width - scaleHeight) / xData.length;
    canvas.save();
    canvas.translate(xStep, 0);
    for (int i = 0; i < xData.length; i++) {
      canvas.drawLine(Offset(0, 0), Offset(0, scaleHeight), axisPaint);
      _drawAxisText(canvas, xData[i],
          alignment: Alignment.center, offset: Offset(-xStep / 2, 10));
      canvas.translate(xStep, 0);
    }
    canvas.restore();
  }

  void drawBarChart(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(xStep, 0);
    for (int i = 0; i < xData.length; i++) {
      canvas.drawRect(
          Rect.fromLTWH(barPading, 0, xStep - 2 * barPading,
                  -(yData[i] / maxData * (size.height - scaleHeight)))
              .translate(-xStep, 0),
          fillPaint);
      canvas.translate(xStep, 0);
    }
    canvas.restore();
  }

  void _drawAxisText(Canvas canvas, String str,
      {Color color = Colors.black,
      bool x = false,
      Alignment alignment = Alignment.centerRight,
      Offset offset = Offset.zero}) {
    TextSpan text = TextSpan(
        text: str,
        style: TextStyle(
          fontSize: 11,
          color: color,
        ));

    _textPainter.text = text;
    _textPainter.layout(); // 进行布局

    Size size = _textPainter.size;

    Offset offsetPos = Offset(-size.width / 2, -size.height / 2)
        .translate(-size.width / 2 * alignment.x + offset.dx, 0.0 + offset.dy);
    _textPainter.paint(canvas, offsetPos);
  }
}
