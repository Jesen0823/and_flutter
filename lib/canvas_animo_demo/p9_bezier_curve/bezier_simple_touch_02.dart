import 'dart:ui';

import 'package:and_flutter/canvas_animo_demo/height_coordinate.dart';
import 'package:and_flutter/canvas_animo_demo/p5_color/color_blend_mode_02.dart';
import 'package:and_flutter/canvas_animo_demo/p8_path_curve/points_path_math_curve_anim_03.dart';
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

  runApp(Paper02());
}

/// 二次贝塞尔曲线动态触控点
class Paper02 extends StatefulWidget {
  const Paper02({Key? key}) : super(key: key);

  @override
  State<Paper02> createState() => _Paper02State();
}

class _Paper02State extends State<Paper02> {
  final TouchInfo touchInfo = TouchInfo();

  @override
  void dispose() {
    touchInfo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _onPanDown, // 按下
      onPanEnd: _onPanEnd, // 抬起
      onPanUpdate: _onPanUpdate, // 更新触点
      child: Container(
        color: Colors.white,
        child: CustomPaint(
          painter: Paper02Painter(repaint: touchInfo),
        ),
      ),
    );
  }

  void _onPanDown(DragDownDetails details) {
    if (touchInfo.points.length < 3) {
      touchInfo.addPoint(details.localPosition);
    } else {
      judgeSelectZone(details.localPosition);
    }
  }

  void _onPanEnd(DragEndDetails details) {}

  void _onPanUpdate(DragUpdateDetails details) {
    judgeSelectZone(details.localPosition, update: true);
  }

  /// 进行点域的判断来确定当前点击的是哪个点。 比如在半径为 6 的区域内算作命中，就计算两点间的距离是否小于 6
  void judgeSelectZone(Offset local, {bool update = false}) {
    for (int i = 0; i < touchInfo.points.length; i++) {
      if (judgePointArea(local, touchInfo.points[i], 15)) {
        touchInfo.selectIndex = i;
        if (update) {
          touchInfo.updatePoint(i, local);
        }
      }
    }
  }

  // 点的距离是否超出指定距离/半径
  bool judgePointArea(Offset src, Offset dst, int r) =>
      (src - dst).distance <= r;
}

class Paper02Painter extends CustomPainter {
  final BetterCoordinate coordinate = BetterCoordinate();

  final TouchInfo repaint;

  Offset p1 = Offset(100, 100);
  Offset p2 = Offset(120, -60);

  late Paint _paint;
  late Path _path;

  List<Offset> pos = [];

  Paint _helpPaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  Paper02Painter({required this.repaint}) : super(repaint: repaint) {
    _paint = Paint()
      ..color = Colors.pinkAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    _path = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);
    canvas.translate(size.width / 2, size.height / 2);
    pos = repaint.points
        .map((e) => e.translate(-size.width / 2, -size.height / 2))
        .toList();

    _path.reset();

    if (pos.length < 3) {
      canvas.drawPoints(PointMode.points, pos, _helpPaint..strokeWidth = 8);
    } else {
      _path.moveTo(pos[0].dx, pos[0].dy);
      _path.quadraticBezierTo(pos[1].dx, pos[1].dy, pos[2].dx, pos[2].dy);
      canvas.drawPath(_path, _paint);
      _drawHelp(canvas);
      _drawSelectPoint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant Paper02Painter oldDelegate) =>
      oldDelegate.repaint != repaint;

  void _drawHelp(Canvas canvas) {
    canvas.drawPoints(PointMode.polygon, pos, _helpPaint..strokeWidth = 1);
    canvas.drawPoints(PointMode.points, pos, _helpPaint..strokeWidth = 8);
  }

  void _drawSelectPoint(Canvas canvas, Size size) {
    Offset? selectPos = repaint.selectPoint;
    if (selectPos == null) return;
    selectPos = selectPos.translate(-size.width / 2, -size.height / 2);
    canvas.drawCircle(
        selectPos,
        10,
        _helpPaint
          ..color = Colors.green
          ..strokeWidth = 2);
  }
}

/// 由于画板需要一个 Listenable 对象来触发重绘，可以将需要改变的数据使用一个类维护起来。
/// ChangeNotifier 是一个实现了 Listenable 的类。
/// 在数据变动时，可以通过 notifyListeners() 来通知监听者，也就是画板对象，让它进行重绘
class TouchInfo extends ChangeNotifier {
  List<Offset> _points = [];
  int _selectIndex = -1;

  List<Offset> get points => _points;

  int get selectIndex => _selectIndex;

  set selectIndex(int value) {
    assert(value != null);
    if (selectIndex == value) return;
    _selectIndex = value;
    notifyListeners();
  }

  void addPoint(Offset point) {
    points.add(point);
    notifyListeners();
  }

  void updatePoint(int index, Offset point) {
    points[index] = point;
    notifyListeners();
  }

  Offset? get selectPoint => _selectIndex == -1 ? null : _points[_selectIndex];
}
