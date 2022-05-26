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

  runApp(Paper25());
}

////////////////////////////////////////
/// 画布剪裁
////////////////////////////////////////
class Paper25 extends StatelessWidget {
  const Paper25({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper25Painter(),
      ),
    );
  }
}

class Paper25Painter extends CustomPainter {
  final CommonCoordinate coordinate = CommonCoordinate();
  late Paint _paint;

  Paper25Painter() {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..color = Colors.blue;
  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);

    var colors = [
      Color(0xFFF60C0C),
      Color(0xFFF3B913),
      Color(0xFFE7F716),
      Color(0xFF3DF30B),
      Color(0xFF0DF6EF),
      Color(0xFF0829FB),
      Color(0xFFB709F4)
    ];
    var pos = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];

    var rect = Rect.fromCenter(center: Offset.zero, width: 360, height: 240);
    // 下面将该rect的画布裁剪
    canvas.drawRect(rect, _paint..color=Colors.black54..style=PaintingStyle.stroke);
    canvas.clipRect(rect, doAntiAlias: true, clipOp: ui.ClipOp.intersect);

    _paint.shader = ui.Gradient.linear(
        rect.centerLeft, rect.centerRight, colors, pos, TileMode.clamp);

    canvas.drawPaint(_paint..blendMode = BlendMode.lighten);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
