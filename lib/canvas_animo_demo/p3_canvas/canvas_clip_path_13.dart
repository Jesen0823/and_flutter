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

  runApp(Paper27());
}

////////////////////////////////////////
/// 剪裁路径path画布区域
////////////////////////////////////////
class Paper27 extends StatelessWidget {
  const Paper27({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper27Painter(),
      ),
    );
  }
}

class Paper27Painter extends CustomPainter {
  final CommonCoordinate coordinate = CommonCoordinate();
  late Paint _paint;
  late Path _path;

  Paper27Painter() {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..color = Colors.blue;

    _path = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);

    _path.lineTo(100, 80);
    _path.lineTo(-50, 200);
    _path.lineTo(0,120);
    _path.close();
    canvas.clipPath(_path);
    // 在被裁剪的画布区域画颜色
    canvas.drawColor(Colors.pink, BlendMode.darken);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
