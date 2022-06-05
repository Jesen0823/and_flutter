import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/// 本文仅完成绘制，没有加入手势动画
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
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            body: Center(
              child: HandleWidget(),
            )));
  }
}
/////////////////////////////////////////////
class HandleWidget extends StatefulWidget {
  final double size;
  final double handleRadius;

  const HandleWidget({Key? key, this.size = 160.0, this.handleRadius = 20.0})
      : super(key: key);

  @override
  State<HandleWidget> createState() => _HandleWidgetState();
}

class _HandleWidgetState extends State<HandleWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: _HandlePainter(handleR: widget.handleRadius),
    );
  }
}

class _HandlePainter extends CustomPainter {
  Paint _paint = Paint();
  var handleR;

  _HandlePainter({this.handleR}) {
    _paint
      ..color = Colors.blueAccent
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
    _paint.color = _paint.color.withAlpha(150);
    canvas.drawCircle(Offset.zero, handleR, _paint);
  }

  @override
  bool shouldRepaint(covariant _HandlePainter oldDelegate) =>
      oldDelegate.handleR != handleR;
}
