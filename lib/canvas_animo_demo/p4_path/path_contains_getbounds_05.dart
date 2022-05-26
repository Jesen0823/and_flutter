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

  runApp(Paper36());
}

////////////////////////////////////////
/// Paint#contains可以判断点Offset在不在路径之内(如下图紫色区域)，
// 这是个非常好用的方法，可以根据这个方法做一些触点判断或简单的碰撞检测。
// Paint#getBounds可以获取当前路径所在的矩形区域，(如下橙色区域)
////////////////////////////////////////
class Paper36 extends StatelessWidget {
  const Paper36({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper36Painter(),
      ),
    );
  }
}

class Paper36Painter extends CustomPainter {
  final CommonCoordinate coordinate = CommonCoordinate();
  late Paint _paint;
  late Paint _rectPaint;
  late Path _path;

  Paper36Painter() {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..color = Colors.pinkAccent;

    _path = Path();

    _rectPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.blueAccent;
  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);

    _path
      ..relativeMoveTo(0, 0)
      ..relativeLineTo(-30, 120)
      ..relativeLineTo(30, 40)
      ..relativeLineTo(30, 30)
      ..close();
    canvas.drawPath(_path, _paint);

    // path区域是否包含该坐标点
    if (_path.contains(Offset(0, 20))) {
      _rectPaint.color = Colors.orange;
    }
    // 画出路径包含的矩形区域
    Rect bounds = _path.getBounds();
    canvas.drawRect(bounds, _rectPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
