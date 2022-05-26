import 'dart:math';

import 'package:and_flutter/canvas_animo_demo/common_coordinate.dart';
import 'package:dash_painter/dash_painter.dart';
import 'package:flutter/material.dart';
/// 默认情况下，画布是以屏幕左上角为变换中心的。
///
/// 在一次变换中，我们可以叠加多个变换，比如下面在旋转的基础上，再叠加缩放变换。
/// 这个变换中心依然是红点，也就是说，在一次变换中，通过平移变换可以用来修改变中心
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
    dashPainter.paint(canvas, path, Paint()..color=Colors.red..style=PaintingStyle.stroke..strokeWidth=1);

    Matrix4 m4 = Matrix4.translationValues(size.width/2, size.height/2, 0);
    Matrix4 rotateM4 = Matrix4.rotationZ(10*pi/180);
    Matrix4 scaleM4 = Matrix4.diagonal3Values(2,2,1);
    m4.multiply(rotateM4);

    Path helpPath = path.transform(m4.storage);
    dashPainter.paint(canvas, helpPath, Paint()..color=Colors.green..style=PaintingStyle.stroke..strokeWidth=2);


    m4.multiply(scaleM4);
    path = path.transform(m4.storage);
    canvas.drawPath(path, paint);


    canvas.drawRect(Offset.zero&size, Paint()..color=Color(0xff00fffc).withOpacity(0.1)..strokeWidth=2);
    canvas.drawCircle(Offset(size.width/2,size.height/2),2,Paint()..color=Colors.red..strokeWidth=3);
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) => true;
}
