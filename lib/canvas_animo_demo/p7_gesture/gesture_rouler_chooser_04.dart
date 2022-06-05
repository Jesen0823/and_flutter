import 'dart:ui' as ui;

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
            child: Container(
              color: Colors.orangeAccent.withAlpha(50),
              padding: EdgeInsets.only(top: 12.0,bottom: 20.0),
              child: RulerChooser(
                onChanged: (value) {
                  print("ruler value: $value");
                },
              ),
            ),
          ),
        ));
  }
}

/// 通过绘制如下的滑动刻度尺，来练习一下水平滑动的操作以及刻度的绘制。
/// 其中包含对边界值的限值、一些数值计算等实用的技巧。
/// 需要指定的属性有，最大值 max 、最小值 min、刻度尺将可以在之间滑动。
// 并且给出一个 onChanged 的回调方法，将当前滑到的值传给用户。
// 在画板中最重要的数据是水平滑动的距离，所以在组件中使用一个 ValueNotifier<double> 的对象传给画板，
// 用于更新重绘。
// 通过 GestureDetector 在水平方向进行监听，
// 核心是进行移动过程中的点位计算，逻辑放在_parser方法中。

const double _kHeightLevel1 = 20; // 短线长
const double _kHeightLevel2 = 25; // 5 线长
const double _kHeightLevel3 = 30; //10 线长
const double _kPrefixOffSet = 5; // 左侧偏移
const double _kVerticalOffSet = 12; // 线顶部偏移
const double _kStrokeWidth = 2; // 刻度宽
const double _kSpacer = 4; // 刻度间隙
const List<Color> _kRulerColors = [
  // 渐变色
  Color(0xFF1426FB),
  Color(0xFF6080FB),
  Color(0xFFBEE0FB),
];
const List<double> _kRulerColorStops = [0.0, 0.2, 0.8];

class RulerChooser extends StatefulWidget {
  final Size size;
  final void Function(double) onChanged;
  final int min;
  final int max;

  const RulerChooser(
      {Key? key,
      this.size = const Size(240.0, 60),
      required this.onChanged,
      this.min = 100,
      this.max = 200})
      : super(key: key);

  @override
  State<RulerChooser> createState() => _RulerChooserState();
}

class _RulerChooserState extends State<RulerChooser> {
  ValueNotifier<double> _dx = ValueNotifier(0.0);
  double dx = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _parser,
      child: CustomPaint(
        size: widget.size,
        painter: _HandlerPainter(dx: _dx, max: widget.max, min: widget.min),
      ),
    );
  }

  void _parser(DragUpdateDetails details) {
    dx += details.delta.dx;

    if (dx > 0) {
      dx = 0.0;
    }
    var limitMax = -(widget.max - widget.min) * (_kSpacer + _kStrokeWidth);
    if (dx < limitMax) {
      dx = limitMax;
    }
    _dx.value = dx;
    widget.onChanged(details.delta.dx / (_kSpacer + _kStrokeWidth));
  }
}

class _HandlerPainter extends CustomPainter {
  var _paint = Paint();
  var _pointPaint = Paint();

  final ValueNotifier<double> dx;
  final int max;
  final int min;

  _HandlerPainter({required this.dx, required this.max, required this.min})
      : super(repaint: dx) {
    _paint
      ..strokeWidth = _kStrokeWidth
      ..shader = ui.Gradient.radial(
          Offset(0, 0), 25, _kRulerColors, _kRulerColorStops, TileMode.mirror);
    _pointPaint
      ..color = Colors.purpleAccent
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    drawArrow(canvas);
    canvas.translate(_kStrokeWidth / 2 + _kPrefixOffSet, _kVerticalOffSet);
    canvas.translate(dx.value, 0);
    drawRuler(canvas);
  }

  @override
  bool shouldRepaint(covariant _HandlerPainter oldDelegate) =>
      oldDelegate.dx != dx || oldDelegate.min != min || oldDelegate.max != max;

  void drawRuler(ui.Canvas canvas) {
    double y = _kHeightLevel1;
    for (int i = min; i < max + 5; i++) {
      if (i % 5 == 0 && i % 10 != 0) {
        y = _kHeightLevel2;
      } else if (i % 10 == 0) {
        y = _kHeightLevel3;
        _simpleDrawText(canvas, i.toString(),
            offset: Offset(-3, _kHeightLevel3 + 5));
      } else {
        y = _kHeightLevel1;
      }
      canvas.drawLine(Offset.zero, Offset(0, y), _paint);
      canvas.translate(_kStrokeWidth + _kSpacer, 0);
    }
  }

  // 绘制三角形尖角
  void drawArrow(Canvas canvas) {
    var path = Path()
      ..moveTo(_kStrokeWidth / 2 + _kPrefixOffSet, 3)
      ..relativeLineTo(-3, 0)
      ..relativeLineTo(3, _kPrefixOffSet)
      ..relativeLineTo(3, -_kPrefixOffSet)
      ..close();
    canvas.drawPath(path, _pointPaint);
  }

  void _simpleDrawText(Canvas canvas, String str,
      {Offset offset = Offset.zero}) {
    var builder = ui.ParagraphBuilder(ui.ParagraphStyle())
      ..pushStyle(
        ui.TextStyle(
            color: Colors.black, textBaseline: ui.TextBaseline.alphabetic),
      )
      ..addText(str);
    canvas.drawParagraph(
        builder.build()
          ..layout(ui.ParagraphConstraints(width: 11.0 * str.length)),
        offset);
  }
}
