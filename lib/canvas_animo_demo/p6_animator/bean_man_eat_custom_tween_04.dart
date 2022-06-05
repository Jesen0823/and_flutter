import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/// 自定义 Tween
// 只对于 Tween 主要就是实现在 t 变化的过程中应该根据 t 变成什么新值。
// 这里写一个ColorDoubleTween 示意一下自定义流程。
// 这个 Tween 负责颜色和 double 类型 同时变化的渐变。
// 首先要有一个基本结构 ColorDouble 来定义需要变化的类型，然后继承自 Tween<ColorDouble>
// 之后重写lerp 方法，根据 t 生成新对象即可。如果有十几个渐变的属性，这样可以更方便操作，
// 不然要写十几个不同的 Tween 。这样的话，打包成一个就行了。
class ColorDouble{
  final Color? color;
  final double value;

  ColorDouble({this.color = Colors.blueAccent,this.value=0});
}

class ColorDoubleTween extends Tween<ColorDouble>{
  ColorDoubleTween({required ColorDouble begin, required ColorDouble end})
  :super(begin: begin,end: end);

  @override
  ColorDouble lerp(double t) => ColorDouble(
    color: Color.lerp(begin?.color, end?.color, t),
    value: (begin!.value+(end!.value-begin!.value)*t)
  );
}
/////////////////////////////////////////////
void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter draw',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            body: Padding(
          padding: const EdgeInsets.only(top: 58.0, left: 20),
          child: BeanMan03(),
        )));
  }
}

///////////////////////////////////////////////////////
class BeanMan03 extends StatefulWidget {
  final Color color;

  BeanMan03({Key? key, this.color = Colors.lightBlue}) : super(key: key);

  @override
  _BeanMan03State createState() => _BeanMan03State();
}

class _BeanMan03State extends State<BeanMan03>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(100, 100),
      painter: BeanMan03Painter(repaint: _controller),
    );
  }
}

class BeanMan03Painter extends CustomPainter {
  final Animation<double> repaint;

  final ColorDoubleTween tween =
      ColorDoubleTween(
          begin: ColorDouble(color: Colors.purpleAccent,value: 2),
          end: ColorDouble(color: Colors.pinkAccent,value: 45)
      );

  Paint _paint = Paint();

  BeanMan03Painter({required this.repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size); //剪切画布
    final double radius = size.width / 2;
    canvas.translate(radius, size.height / 2);
    _drawHead(canvas, size);
    _drawEye(canvas, radius);
  }

  //绘制头
  void _drawHead(Canvas canvas, Size size) {
    var rect = Rect.fromCenter(
        center: Offset(0, 0), height: size.width, width: size.height);
    var a = tween.evaluate(repaint).value / 180 * pi;
    canvas.drawArc(rect, a, 2 * pi - a.abs() * 2, true,
        _paint..color = tween.evaluate(repaint).color ?? Colors.black);
  }

  //绘制眼睛
  void _drawEye(Canvas canvas, double radius) {
    canvas.drawCircle(Offset(radius * 0.15, -radius * 0.6), radius * 0.12,
        _paint..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant BeanMan03Painter oldDelegate) =>
      oldDelegate.repaint != repaint;
}
