import 'dart:math';

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

  runApp(Paper38());
}

////////////////////////////////////////
/// Patn#combine用于结合两个路径，并生成新路径，可用于生成复杂的路径。
// 一共有如下五种联合方式，效果如下图:
////////////////////////////////////////
class Paper38 extends StatelessWidget {
  const Paper38({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper38Painter(),
      ),
    );
  }
}

class Paper38Painter extends CustomPainter {
  final CommonCoordinate coordinate = CommonCoordinate();
  late Paint _paint;
  late Path _path;

  Paper38Painter() {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..color = Colors.pinkAccent;

    _path = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);

    _path
      ..relativeMoveTo(0, 0)
      ..relativeLineTo(-30, 120)
      ..relativeLineTo(30, -30)
      ..relativeLineTo( 30,30)
      ..close();

    var pathOval =Path()..addOval(Rect.fromCenter(center: Offset(0, 0),width: 60,height: 60));
    canvas.drawPath(Path.combine(PathOperation.difference, _path, pathOval), _paint);

    canvas.translate(120, 0);
    canvas.drawPath(Path.combine(PathOperation.intersect, _path, pathOval), _paint);

    canvas.translate(120, 0);
    canvas.drawPath(Path.combine(PathOperation.union, _path, pathOval), _paint);

    canvas.translate(-120*3.0, 0);
    canvas.drawPath(Path.combine(PathOperation.reverseDifference, _path, pathOval), _paint);

    canvas.translate(-120, 0);
    canvas.drawPath(Path.combine(PathOperation.xor, _path, pathOval), _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
