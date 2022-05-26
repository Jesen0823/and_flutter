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

  runApp(Paper39());
}

////////////////////////////////////////
/// 通过path.computeMetrics()，可以获取一个可迭代PathMetrics类对象
/// 它迭代出的是PathMetric对象，也就是每个路径的测量信息。
////////////////////////////////////////
class Paper39 extends StatelessWidget {
  const Paper39({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper39Painter(),
      ),
    );
  }
}

class Paper39Painter extends CustomPainter {
  final CommonCoordinate coordinate = CommonCoordinate();
  late Paint _paint;
  late Path _path;

  Paper39Painter() {
    _paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.pinkAccent;

    _path = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);

    _path ..relativeMoveTo(0, 0)
      ..relativeLineTo(-30, 120)
      ..relativeLineTo(30, -30)
      ..relativeLineTo(30, 30)
      ..close();

    _path.addOval(Rect.fromCenter(center: Offset.zero, width: 50, height: 50));
    
    ui.PathMetrics pms = _path.computeMetrics();
    pms.forEach((element) { 
      print("---length:${element.length}, index:${element.contourIndex}, is closed:${element.isClosed}");

      ui.Tangent? tangent = element.getTangentForOffset(element.length*0.5);
      if(tangent==null) return;
      print("---position:${tangent.position}, angle:${tangent.angle}, vector:${tangent.vector}");

      canvas.drawCircle(tangent.position, 5, Paint()..color=Colors.deepOrange);
    });
    canvas.drawPath(_path, _paint..color=Colors.cyan);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
