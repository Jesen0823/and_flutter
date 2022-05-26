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

  runApp(Paper24());
}

class Paper24 extends StatelessWidget {
  const Paper24({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper24Painter(),
      ),
    );
  }
}

class Paper24Painter extends CustomPainter {
  late final Paint _paint;
  late final CommonCoordinate _coordinate;
  late final Path _path;

  Paper24Painter() {
    _paint = Paint();
    _coordinate = CommonCoordinate();
    _path = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    _coordinate.paint(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);

    _paint
      ..style = PaintingStyle.fill
      ..color = Colors.green
      ..isAntiAlias = true;

    _path.lineTo(60, 60);
    _path.lineTo(-60, 60);
    _path.lineTo(60, -60);
    _path.lineTo(-60, -60);
    _path.close();
    canvas.drawPath(_path, _paint);
    canvas.translate(140, 0);
    canvas.drawPath(
        _path,
        _paint
          ..style = PaintingStyle.stroke..color=Colors.pinkAccent
          ..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>false;
}
