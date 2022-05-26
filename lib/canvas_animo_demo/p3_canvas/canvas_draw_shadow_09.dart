import 'package:and_flutter/canvas_animo_demo/common_coordinate.dart';
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

  runApp(Paper23());
}

class Paper23 extends StatelessWidget {
  const Paper23({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper23Painter(),
      ),
    );
  }
}

class Paper23Painter extends CustomPainter {
  late final Paint _paint;

  Paper23Painter() {
    _paint = Paint();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    _paint
      ..style = PaintingStyle.fill
      ..color = Colors.white
      ..isAntiAlias = true;

    double relativeX = 100;
    double angle = 0;
    double width = 10;
    double height = 10;
    double center = relativeX + width / 2;
    if (angle == 0) {
      center = relativeX + width / 4;
    } else if (angle == 2) {
      center = relativeX + width / 4 * 3;
    }

    Path trianglePath = Path()
      ..addPolygon([
        Offset(relativeX, height),
        Offset(relativeX + width, height),
        Offset(center, 0),
      ], false)
      ..close();

    Path rectanglePath = Path()
      ..addRRect(RRect.fromLTRBR(0, 10, 160, 100, Radius.circular(8)))
      ..close();

    canvas.drawShadow(
        Path.combine(PathOperation.xor, trianglePath, rectanglePath),
        Colors.black,
        3,
        false);

    canvas.drawPath(
        Path.combine(PathOperation.xor, trianglePath, rectanglePath),
        _paint..color = Colors.white);
    _paint.maskFilter = MaskFilter.blur(BlurStyle.inner, 20);

    canvas.drawPath(
        Path.combine(PathOperation.xor, trianglePath, rectanglePath),
        _paint..color = Color(0xffBEC4C0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>false;
}
