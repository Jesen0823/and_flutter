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

  runApp(Paper2());
}

////////////////////////////////////////////
/////  线帽  线接类型  斜接限制
/////////////////////////////////////////////
class Paper2 extends StatelessWidget {
  const Paper2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper2Painter(),
      ),
    );
  }
}

class Paper2Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    drawStrokeCap(canvas);
    drawStrokeJoin(canvas);
    drawStrokeMiterLimit(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 线帽测试
void drawStrokeCap(Canvas canvas) {
  Paint paint = Paint();
  paint
    ..style = PaintingStyle.stroke
    ..color = Colors.blueGrey
    ..strokeWidth = 20;

  canvas.drawLine(
      Offset(50, 50), Offset(50, 150), paint..strokeCap = StrokeCap.butt);

  canvas.drawLine(Offset(50 + 50.0, 50), Offset(50 + 50.0, 150),
      paint..strokeCap = StrokeCap.round);

  canvas.drawLine(Offset(50 + 50.0 * 2, 50), Offset(50 + 50.0 * 2, 150),
      paint..strokeCap = StrokeCap.square);

  //测试线
  canvas.drawLine(
      Offset(0, 50),
      Offset(1600, 50),
      paint
        ..strokeWidth = 1
        ..color = Colors.cyanAccent);
  canvas.drawLine(
      Offset(0, 150),
      Offset(1600, 150),
      paint
        ..strokeWidth = 1
        ..color = Colors.cyanAccent);
}
// 线接类型
void drawStrokeJoin(Canvas canvas) {
  Paint paint = Paint();
  Path path = Path();
  paint
    ..style = PaintingStyle.stroke
    ..color = Colors.greenAccent
    ..strokeWidth = 20;
  path.moveTo(50, 50);
  path..lineTo(50,150);
  path.relativeLineTo(100,-50);
  path.relativeLineTo(0, 100);
  canvas.drawPath(path, paint..strokeJoin=StrokeJoin.bevel);

  path.reset();
  path.moveTo(50 + 150.0, 50);
  path.lineTo(50 + 150.0, 150);
  path.relativeLineTo(100, -50);
  path.relativeLineTo(0, 100);
  canvas.drawPath(path, paint..strokeJoin = StrokeJoin.miter);

  path.reset();
  path.moveTo(50 + 150.0 * 2, 50);
  path.lineTo(50 + 150.0 * 2, 150);
  path.relativeLineTo(100, -50);
  path.relativeLineTo(0, 100);
  canvas.drawPath(path, paint..strokeJoin = StrokeJoin.round);
}

/// 斜接限制
void drawStrokeMiterLimit(Canvas canvas) {
  Paint paint =  Paint();
  Path path =  Path();
  paint
    ..style = PaintingStyle.stroke
    ..color = Colors.blue
    ..strokeJoin = StrokeJoin.miter
    ..strokeWidth = 20;
  for (int i = 0; i < 4; i++) {
    path.reset();
    path.moveTo(50 + 150.0 * i, 50);
    path.lineTo(50 + 150.0 * i, 150);
    path.relativeLineTo(100, -(40.0 * i + 20));
    canvas.drawPath(path, paint..strokeMiterLimit = 2);
  }
  for (int i = 0; i < 4; i++) {
    path.reset();
    path.moveTo(50 + 150.0 * i, 50 + 150.0);
    path.lineTo(50 + 150.0 * i, 150 + 150.0);
    path.relativeLineTo(100, -(40.0 * i + 20));
    canvas.drawPath(path, paint..strokeMiterLimit = 3);
  }
}
