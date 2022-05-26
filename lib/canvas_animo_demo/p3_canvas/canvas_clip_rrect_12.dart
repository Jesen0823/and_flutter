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

  runApp(Paper26());
}

////////////////////////////////////////
/// 剪裁圆角矩形画布区域
////////////////////////////////////////
class Paper26 extends StatelessWidget {
  const Paper26({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper26Painter(),
      ),
    );
  }
}

class Paper26Painter extends CustomPainter {
  final CommonCoordinate coordinate = CommonCoordinate();
  late Paint _paint;

  Paper26Painter() {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..color = Colors.blue;
  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);

    var rect = Rect.fromCenter(center: Offset.zero, width: 240, height: 180);
    // 下面将该rect的画布裁剪
    canvas.drawRect(rect, _paint..color=Colors.black54..style=PaintingStyle.stroke);
    canvas.clipRRect(RRect.fromRectAndRadius(rect, Radius.circular(30)));
    // 在被裁剪的画布区域画颜色
    canvas.drawColor(Colors.pink, BlendMode.darken);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
