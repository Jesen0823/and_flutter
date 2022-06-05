import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:and_flutter/canvas_animo_demo/common_coordinate.dart';
import 'package:flutter/services.dart';

import '../height_coordinate.dart';

/// 绘制数学函数曲线
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
        // 使用CustomPaint
        painter: Paper01Painter(),
      ),
    );
  }
}

const List<Color> colors = [
  Color(0xFFF60C0C),
  Color(0xFFF3B913),
  Color(0xFFE7F716),
  Color(0xFF3DF30B),
  Color(0xFF0DF6EF),
  Color(0xFF0829FB),
  Color(0xFFB709F4),
];
const List<double> pos = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];


class Paper01Painter extends CustomPainter {
  final BetterCoordinate coordinate = BetterCoordinate(gridColor: Colors.grey.withAlpha(100));
  final List<Offset> points = [];

  late Paint _paint;


  Paper01Painter():super(){
    _paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    _paint.shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(100, 0),
      colors,
      pos,
      TileMode.mirror
    );

    //initPoints();
    initPointsWithPolar();
  }

  // 普通函数初始化
  void initPoints() {
    final double step = 8;
    final double min = -360;
    final double max = 360;
    for (double x = min; x <= max; x += step) {
      points.add(Offset(x, f1(x)));
    }
  }

  /// 极坐标表示的函数
  void initPointsWithPolar() {
    final double step = 2;
    final double min = 0;
    final double max = 360*3.0;
    for (double x = min; x <= max; x += step) {
      double thta = (pi/180*x); // 角度转弧度
      var p = f5(thta);
      points.add(Offset(p*cos(thta), p*sin(thta)));
    }
  }

  /// 函数 y = -x²/200 + 100
  double f1(double x) {
    double y = -x * x / 200 + 100;
    return y;
  }
  /// 函数 ρ = 10 * θ
  double f2(double thta){
    double p = 10*thta;
    return p;
  }
  /// 函数 ρ = 100*(1-cosθ)
  double f3(double thta){
    double p = 100*(1-cos(thta));
    return p;
  }
  /// 函数 ρ = 150*|sin(5*θ)|
  double f4(double thta){
    double p =  150*sin(5*thta).abs();
    return p;
  }
  /// 函数 ρ=(e^(cosθ)- 2cos(4θ) + [sin(θ/12)]^5)*100
  double f5(double thta){
    double p =  50*(pow(e,cos(thta)) - 2 * cos(4 * thta) +pow(sin(thta / 12), 5));
    return p;
  }
  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);
    canvas.translate(size.width/2, size.height/2);

    /*canvas.drawPoints(ui.PointMode.points, points, _paint);
    canvas.translate(0, 40);*/
    canvas.drawPoints(ui.PointMode.polygon, points, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
