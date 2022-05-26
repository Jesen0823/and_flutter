import 'dart:math';

import 'package:and_flutter/canvas_animo_demo/common_coordinate.dart';
import 'package:dash_painter/dash_painter.dart';
import 'package:flutter/material.dart';

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

/// 如何以任意点为变换中心呢，比如以 20,20 点为变换中心，进行旋转和缩放操作。
/// 实现思路也非常简单，定义两个偏移的矩阵，在旋转和缩放前，先叠加 center ，让变换中心变为 20,20 。
/// 在最后为了不影响结果，在通过 back 矩阵，平移会取即可。

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
    // dashPainter.paint(canvas, path, Paint()..color=Colors.red..style=PaintingStyle.stroke..strokeWidth=1);

    Matrix4 m4 = Matrix4.translationValues(size.width/2, size.height/2, 0);
    Matrix4 center = Matrix4.translationValues(20, 20, 0);
    Matrix4 back = Matrix4.translationValues(-20, -20, 0);

    Matrix4 rotateM4 = Matrix4.rotationZ(10*pi/180);
    Matrix4 scaleM4 = Matrix4.diagonal3Values(2,2,1);
    drawHelp(m4, center, rotateM4, back, path, canvas);
    m4.multiply(center);
    m4.multiply(rotateM4);
    m4.multiply(scaleM4);
    m4.multiply(back);
    path = path.transform(m4.storage);
    canvas.drawPath(path, paint);


    canvas.drawRect(Offset.zero&size, Paint()..color=Color(0xff00fffc).withOpacity(0.1));
    canvas.drawCircle(Offset(size.width/2+20,size.height/2+20),2,Paint()..color=Colors.red);
  }

  void drawHelp(Matrix4 m4, Matrix4 center, Matrix4 rotateM4, Matrix4 back, Path path, Canvas canvas) {
    Matrix4 m = m4.multiplied(center);
    m.multiply(rotateM4);
    m.multiply(back);
    Path helpPath = path.transform(m.storage);
    dashPainter.paint(
        canvas,
        helpPath,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) => true;
}