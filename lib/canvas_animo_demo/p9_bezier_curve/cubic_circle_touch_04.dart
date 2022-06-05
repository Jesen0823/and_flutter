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

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Paper04(),
  ));
}

/// 三阶贝塞尔曲线动态模拟圆
class Paper04 extends StatefulWidget {
  const Paper04({Key? key}) : super(key: key);

  @override
  State<Paper04> createState() => _Paper04State();
}

class _Paper04State extends State<Paper04> {
  final TouchInfo touchInfo = TouchInfo();
//单位圆(即半径为1)控制线长
  final rate = 0.551915024494;
  double _radius = 150;


  @override
  void initState() {
    super.initState();
    touchInfo.setPoints(_initPoints());
  }

  @override
  void dispose() {
    touchInfo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _onPanDown, // 按下
      onPanUpdate: _onPanUpdate, // 更新触点
      child: Container(
        color: Colors.white,
        child: CustomPaint(
          painter: Paper04Painter(repaint: touchInfo),
        ),
      ),
    );
  }

  void _onPanDown(DragDownDetails details) {
    if (touchInfo.points.length < 4) {
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
    Size size = MediaQuery.of(context).size;
    local=local.translate(-size.width/2, -size.height/2);
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

  List<Offset> _initPoints() {
    final List<Offset> pos = [];
    //第一段线
    pos.add(Offset(0, rate) * _radius);
    pos.add(Offset(1 - rate, 1) * _radius);
    pos.add(Offset(1, 1) * _radius);
    //第二段线
    pos.add(Offset(1 + rate, 1) * _radius);
    pos.add(Offset(2, rate) * _radius);
    pos.add(Offset(2, 0) * _radius);
    //第三段线
    pos.add(Offset(2, -rate) * _radius);
    pos.add(Offset(1 + rate, -1) * _radius);
    pos.add(Offset(1, -1) * _radius);
    //第四段线
    pos.add(Offset(1 - rate, -1) * _radius);
    pos.add(Offset(0, -rate) * _radius);
    pos.add(Offset(0, 0));
    return pos;
  }
}

class Paper04Painter extends CustomPainter {
  final BetterCoordinate coordinate = BetterCoordinate();

  final TouchInfo repaint;

  late Paint _paint;
  late Path _path;

  List<Offset> pos = [];

  Paint _helpPaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  Paper04Painter({required this.repaint}) : super(repaint: repaint) {
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

    pos = repaint.points;

    _path.reset();

    _path.moveTo(0, 0);
    for (int i = 0; i < pos.length/3; i++) {
      _path.cubicTo(pos[3 * i + 0].dx, pos[3 * i + 0].dy, pos[3 * i + 1].dx,
          pos[3 * i + 1].dy, pos[3 * i + 2].dx, pos[3 * i + 2].dy);
    }
    canvas.drawPath(_path, _paint);
    _drawHelp(canvas);
    _drawSelectPoint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant Paper04Painter oldDelegate) =>
      oldDelegate.repaint != repaint;

  void _drawHelp(Canvas canvas) {
    _helpPaint..strokeWidth = 1..color=Colors.purple;
    canvas.drawLine(pos[0], pos[11], _helpPaint);
    canvas.drawLine(pos[1], pos[2], _helpPaint);
    canvas.drawLine(pos[2], pos[3], _helpPaint);
    canvas.drawLine(pos[4], pos[5], _helpPaint);
    canvas.drawLine(pos[5], pos[6], _helpPaint);
    canvas.drawLine(pos[7], pos[8], _helpPaint);
    canvas.drawLine(pos[8], pos[9], _helpPaint);
    canvas.drawLine(pos[10], pos[11], _helpPaint);
    canvas.drawLine(pos[11], pos[0], _helpPaint);
    canvas.drawPoints(PointMode.points, pos, _helpPaint..strokeWidth = 8);
  }

  void _drawSelectPoint(Canvas canvas, Size size) {
    Offset? selectPos = repaint.selectPoint;
    if (selectPos == null) return;
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

  void setPoints(List<Offset> pos) {
    _points = pos;
  }

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

  void reset() {
    _points.clear();
    _selectIndex = -1;
    notifyListeners();
  }

  Offset? get selectPoint => _selectIndex == -1 ? null : _points[_selectIndex];
}
