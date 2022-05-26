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

  runApp(Paper4());
}

class Paper4 extends StatelessWidget {
  const Paper4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: PaperPainter(),
      ),
    );
  }
}

class PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    drawShaderLinear(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void drawShaderLinear(Canvas canvas) {
    var colors = [
      Color(0xFFF60C0C),
      Color(0xFFF3B913),
      Color(0xFFE7F716),
      Color(0xFF3DF30B),
      Color(0xFF0DF6EF),
      Color(0xFF08AbDB),
      Color(0xFFB709F4),
    ];

    var pos = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];

    Paint paint = Paint();
    paint
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeJoin = StrokeJoin.miter
      ..strokeWidth = 120;

    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(100, 0), colors, pos, TileMode.clamp);
    canvas.drawLine(
      Offset(0, 100),
      Offset(200, 100),
      paint,
    );

    paint.shader = ui.Gradient.linear(Offset(0 + 220.0, 0),
        Offset(100 + 220.0, 0), colors, pos, TileMode.repeated);
    canvas.drawLine(
      Offset(0 + 220.0, 100),
      Offset(200 + 220.0, 100),
      paint,
    );

    paint.shader = ui.Gradient.linear(Offset(0 + 220.0 * 2, 0),
        Offset(100 + 220.0 * 2, 0), colors, pos, TileMode.mirror);
    canvas.drawLine(
      Offset(0 + 220.0 * 2, 100),
      Offset(200 + 220.0 * 2, 100),
      paint,
    );
  }
}
