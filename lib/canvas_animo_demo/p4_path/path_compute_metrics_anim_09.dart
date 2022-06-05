import 'dart:ui';
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

  runApp(Paper40());
}

////////////////////////////////////////////
/// 路径测量和动画搭档起来，才能更看出它的价值，
/// 下面将实现小球沿路径动画，使用动画控制器让数字在 3 秒内从 0 运动到 1，达到动画效果。
/// ///////////////////////////////////////////////////
class Paper40 extends StatefulWidget {
  @override
  _Paper40State createState() => _Paper40State();
}

class _Paper40State extends State<Paper40> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: Duration(seconds: 6), vsync: this)
      ..forward()..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        // 使用CustomPaint
        painter: Paper40Painter(progress: _ctrl),
      ),
    );
  }
}

class Paper40Painter extends CustomPainter {
  final Animation<double> progress;

  Paper40Painter({required this.progress}) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    Paint paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 1
      ..isAntiAlias=true
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path
      ..relativeMoveTo(0, 0)
      ..relativeLineTo(-30, 120)
      ..relativeLineTo(30, -30)
      ..relativeLineTo(30, 30)
      ..close();

    path.addOval(Rect.fromCenter(center: Offset.zero, width: 50, height: 50));

    PathMetrics pms = path.computeMetrics();
    pms.toList().forEach((pm) {
      Tangent? tangent = pm.getTangentForOffset(pm.length * progress.value);
      if(tangent ==null) return;
      canvas.drawCircle(
          tangent.position, 5, Paint()..color = Colors.deepOrange);
    });

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(Paper40Painter oldDelegate) =>
      oldDelegate.progress != progress;
}