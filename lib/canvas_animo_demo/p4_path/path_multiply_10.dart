import 'dart:math';

import 'package:and_flutter/canvas_animo_demo/common_coordinate.dart';
import 'package:dash_painter/dash_painter.dart';
import 'package:flutter/material.dart';
/// 默认情况下，画布是以屏幕左上角为变换中心的。
///
/// 通过 平移变换 ，形成如下路径:
/// Matrix4 m4 = Matrix4.translationValues(size.width/2, size.height/2, 0);
// path = path.transform(m4.storage
// 这时只要在 m4 的基础上 叠加 旋转变换，这样对于 旋转变换 来说，变换中心就是上面红点所示，如下图所示。
// 变换效果的叠加，本质上就是两个 4*4 矩阵的乘法，通过 multiply 方法实现。注意这个方法无返回值，会改变 m4 的值
///
void main() {
  runApp(
    Container(
      color: Colors.white,
      child: CustomPaint(
        painter: PathPainter(),
      ),
    ),
  );
}

class PathPainter extends CustomPainter {
  CommonCoordinate coordinate = CommonCoordinate();
  DashPainter dashPainter = DashPainter();

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);
    Paint paint = Paint()..style = PaintingStyle.stroke;
    Path path = Path()
      ..moveTo(0, 0)
      ..relativeLineTo(40, 40)
      ..relativeLineTo(0, -40)
      ..close();
    dashPainter.paint(
        canvas,
        path,
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);

    Matrix4 m4 = Matrix4.translationValues(size.width / 2, size.height / 2, 0);
    Matrix4 rotateM4 = Matrix4.rotationZ(30 * pi / 180); // 旋转30°
    m4.multiply(rotateM4);
    path = path.transform(m4.storage);
    canvas.drawPath(path, paint);

    canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..color = Color(0xff00fffc).withOpacity(0.1)
          ..strokeWidth = 2);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 2,
        Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) => true;
}
