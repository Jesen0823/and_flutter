import 'dart:ui';
import 'package:and_flutter/canvas_animo_demo/common_coordinate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(Paper01());
}

class Paper01 extends StatelessWidget {
  const Paper01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper01Painter(),
      ),
    );
  }
}

class Paper01Painter extends CustomPainter{
  static const double step=15;
  final CommonCoordinate coordinate = CommonCoordinate(step: step);

  final List<Color> colors = List<Color>.generate(256, (index) => Color.fromARGB(255-index,255,0,0));
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    //
    canvas.save();
    canvas.translate(size.width/2, size.height/2);

    canvas.translate(-step*8.0, -step*8.0);
    colors.asMap().forEach((i, color) {
      int line = (i%16);//行
      int row = i~/16;// 列
      var topLeft = Offset(step*line, step*row);
      var rect = Rect.fromPoints(topLeft, topLeft.translate(step, step));
      canvas.drawRect(rect, _paint..color=color);
    });

    canvas.restore();
    coordinate.paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>false;

}


