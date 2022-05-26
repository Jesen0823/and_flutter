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

  runApp(Paper35());
}

////////////////////////////////////////
/// 类椭圆曲线路径
/// arcTo 用于圆弧路径，指定一个矩形域，形成椭圆。
// 指定起始弧度，和扫描弧度，就可以从椭圆上截取出圆弧。
// 最后一参代表是否强行移动，如果为true，如图左，绘制圆弧时会先移动到起点。
////////////////////////////////////////
class Paper35 extends StatelessWidget {
  const Paper35({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper35Painter(),
      ),
    );
  }
}

class Paper35Painter extends CustomPainter {
  final CommonCoordinate coordinate = CommonCoordinate();
  late Paint _paint;
  late Path _path;

  Paper35Painter() {
    _paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.orange;

    _path = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);

    var rect = Rect.fromCenter(center: Offset(0,0), width: 160, height: 100);
    _path.lineTo(30, 30);
    _path.arcTo(rect, 0, pi*1.5, true);
    canvas.drawPath(_path, _paint);

    _path.reset();
    canvas.translate(200, 0);
    _path.lineTo(30,30);
    _path.arcTo(rect, 0, pi*1.5, false);
    canvas.drawPath(_path, _paint..color=Colors.deepPurpleAccent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
