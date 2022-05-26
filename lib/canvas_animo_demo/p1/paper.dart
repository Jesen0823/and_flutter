import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Paper extends StatelessWidget {
  const Paper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: PaperPainter(),
      ),
    );
  }
}

/// CustomPaint 组件可以用来显示绘制出的东西。需要传入 CustomPainter 对象。
/// 自定义 PaperPainter 类继承 CustomPainter。 在其中的paint方法中可以拿到的画布Canvas。
class PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 创建画笔
    final Paint paint = Paint();
    // 绘制圆
    canvas.drawCircle(Offset(100, 100), 10, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
