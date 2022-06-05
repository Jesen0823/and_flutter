import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 像 Switch、Slider 这样的组件都会向外界提供回调方法，我们也可以将距离和角度回调给使用者。
// 比如下面通过控制器旋转来对蓝色的 Container 进行操作。
void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(HomeApp());
}

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  double _rotate = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: _rotate,
              child: Container(
                color: Colors.blueAccent,
                width: 100,
                height: 100,
              ),
            ),
            HandleWidget(onMove: _onMove)
          ],
        ),
      ),
    );
  }

  void _onMove(double rotate, double distance) {
    setState(() {
      _rotate = rotate;
    });
  }
}

/////////////////////////////////////////////
class HandleWidget extends StatefulWidget {
  final double size;
  final double handleRadius;

  // 定义回调函数
  final void Function(double rotate, double distance) onMove;

  const HandleWidget(
      {Key? key,
      this.size = 160.0,
      this.handleRadius = 20.0,
      required this.onMove})
      : super(key: key);

  @override
  State<HandleWidget> createState() => _HandleWidgetState();
}

class _HandleWidgetState extends State<HandleWidget> {
  ValueNotifier<Offset> _offset = ValueNotifier(Offset.zero);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: reset,
      onPanUpdate: parser,
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _HandlePainter(
            color: Colors.green, handleR: widget.handleRadius, offset: _offset),
      ),
    );
  }

  reset(DragEndDetails details) {
    _offset.value = Offset.zero;
    widget.onMove(0, 0);
  }

  parser(DragUpdateDetails details) {
    final offset = details.localPosition;
    double dx = 0.0;
    double dy = 0.0;
    dx = offset.dx - widget.size / 2;
    dy = offset.dy - widget.size / 2;
    var rad = atan2(dx, dy);
    if (dx < 0) {
      rad += 2 * pi;
    }
    var bgR = widget.size / 2 - widget.handleRadius;
    var thta = rad - pi / 2;
    var d = sqrt(dx * dx + dy * dy);
    if (d > bgR) {
      dx = bgR * cos(thta);
      dy = -bgR * sin(thta);
    }
    widget.onMove(thta, d); // 回调
    _offset.value = Offset(dx, dy);
  }
}

class _HandlePainter extends CustomPainter {
  Paint _paint = Paint();
  var handleR;
  final ValueNotifier<Offset> offset;
  final Color color;

  _HandlePainter({this.handleR, required this.offset, this.color = Colors.cyan})
      : super(repaint: offset) {
    _paint
      ..color = color.withAlpha(100)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);

    final bgR = size.width / 2 - handleR;

    canvas.translate(size.width / 2, size.height / 2);
    _paint.color = _paint.color.withAlpha(100);
    canvas.drawCircle(Offset(0, 0), bgR, _paint);

    _paint.color = color.withAlpha(150);
    canvas.drawCircle(
        Offset(offset.value.dx, offset.value.dy), handleR, _paint);

    _paint.color = color;
    _paint.style = PaintingStyle.fill;
    canvas.drawLine(Offset.zero, offset.value, _paint);
  }

  @override
  bool shouldRepaint(covariant _HandlePainter oldDelegate) =>
      oldDelegate.offset != offset ||
      oldDelegate.color != color ||
      oldDelegate.handleR != handleR;
}
