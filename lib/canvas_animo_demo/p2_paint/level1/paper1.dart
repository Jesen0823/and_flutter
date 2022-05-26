import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(Paper1());
}
///////////////////////////////////////////////
/// paint 属性：颜色，线宽，画笔样式，抗锯齿
/////////////////////////////////////////////////
class Paper1 extends StatelessWidget {
  const Paper1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper1Painter(),
      ),
    );
  }
}

class Paper1Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
     drawIsAntiAliasColor(canvas);
    //drawStyleStrokeWidth(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
  // 验证抗锯齿
  void drawIsAntiAliasColor(Canvas canvas) {
    Paint paint = Paint();
    canvas.drawCircle(
        Offset(120, 120), 100, paint
      ..color = Colors.blue
      ..strokeWidth = 5
    );
    canvas.drawCircle(
        Offset(120 + 240, 120), 100, paint
      ..color = Colors.blueAccent
      ..isAntiAlias = false
    );
  }

  // 测试 style 和 strokeWidth 属性
  void drawStyleStrokeWidth(Canvas canvas) {
    Paint paint = Paint()..color = Colors.red;
    canvas.drawCircle(
        Offset(120, 120),
        100,
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 50);
    canvas.drawCircle(
        Offset(120 + 240.0, 120),
        100,
        paint
          ..strokeWidth = 30
          ..style = PaintingStyle.fill);
    //测试线
    canvas.drawLine(
        Offset(0, 180 - 150.0),
        Offset(1600, 180 - 150.0),
        paint
          ..strokeWidth = 1
          ..color = Colors.blueAccent);
  }
}