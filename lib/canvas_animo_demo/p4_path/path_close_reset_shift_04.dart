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
/// path#close ：用于将路径尾点和起点，进行路径封闭。
// path#reset ：用于将路径进行重置，清除路径内容。
// path#shift ：指定点Offset将路径进行平移，且返回一条新的路径。
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
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..color = Colors.blue;

    _path = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);

    _paint
      ..color = Colors.green
      ..style = PaintingStyle.stroke
    ..strokeWidth=2;
    _path
      ..lineTo(100, 100)
      ..relativeLineTo(0, -50)
      ..close();
    canvas.drawPath(_path, _paint);
    canvas.drawPath(_path.shift(Offset(100, 0)), _paint);
    canvas.drawPath(_path.shift(Offset(200, 100)), _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
