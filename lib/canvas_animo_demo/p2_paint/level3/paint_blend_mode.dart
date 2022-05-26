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

  runApp(Paper8());
}

/// BlendMode 在组件中的应用有 Image 组件和 ColorFilter 组件
// 用于将目标与一个颜色叠合,一共有如下 29 种叠合模式，这里看一下效果。
class Paper8 extends StatefulWidget {
  @override
  _PaperState createState() => _PaperState();
}

class _PaperState extends State<Paper8> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PaperPainter(),
    );
  }
}

class PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    drawBlendMode(canvas, BlendMode.lighten);
    canvas.translate(150, 0);
    drawBlendMode(canvas, BlendMode.hue);
    canvas.translate(150, 0);
    drawBlendMode(canvas, BlendMode.plus);
    canvas.translate(150, 0);
    drawBlendMode(canvas, BlendMode.hardLight);
  }

  void drawBlendMode(Canvas canvas, BlendMode mode) {
    var paint = Paint();
    canvas.drawCircle(Offset(100, 100), 50, paint..color = Color(0x88ff0000));

    canvas.drawCircle(
        Offset(140, 70),
        50,
        paint
          ..color = Color(0x8800ff00)
          ..blendMode = mode);

    canvas.drawCircle(
        Offset(140, 130),
        50,
        paint
          ..color = Color(0x880000ff)
          ..blendMode = mode);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
