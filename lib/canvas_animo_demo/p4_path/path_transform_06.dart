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

  runApp(Paper37());
}

////////////////////////////////////////
/// Path#transform: 路径变换
// 对于对称性图案，当已经有一部分单体路径，可以根据一个4*4的矩阵对路径进行变换。
// 可以使用Matrix4对象进行辅助生成矩阵。能很方便进行旋转、平移、缩放、斜切等变换效果。
////////////////////////////////////////
class Paper37 extends StatelessWidget {
  const Paper37({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper37Painter(),
      ),
    );
  }
}

class Paper37Painter extends CustomPainter {
  final CommonCoordinate coordinate = CommonCoordinate();
  late Paint _paint;
  late Paint _rectPaint;
  late Path _path;

  Paper37Painter() {
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
      ..relativeLineTo(30, -30)
      ..relativeLineTo( 30,30)
      ..close();
    canvas.drawPath(_path, _paint);

    for(int i = 0; i < 8; i++){
      Path path2 = _path.transform(Matrix4.rotationZ(i*pi/4).storage);
      canvas.drawPath(path2, _paint);
    }
    // 画出路径包含的矩形区域
    Rect bounds = _path.getBounds();
    canvas.drawRect(bounds, _rectPaint..color=Colors.cyan);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
