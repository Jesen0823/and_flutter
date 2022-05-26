import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

/// ColorFilter 对象可以使用变换矩阵或颜色叠合模式对绘制的对象进行滤色处理
void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(Paper10());
}

class Paper10 extends StatefulWidget {
  const Paper10({Key? key}) : super(key: key);

  @override
  State<Paper10> createState() => _Paper10State();
}

class _Paper10State extends State<Paper10> {
  ui.Image? _img;

  bool get hasImage => _img != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper10Painter(_img),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    _img = await loadImageFromAsset('assets/images/advert_.jpg');
    setState(() {});
  }

  Future<ui.Image>? loadImageFromAsset(String path) async {
    ByteData data = await rootBundle.load(path);
    Uint8List bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return decodeImageFromList(bytes);
  }
}

class Paper10Painter extends CustomPainter {
  ui.Image? img;

  Paper10Painter(this.img);

  @override
  void paint(Canvas canvas, Size size) {
    if (img == null) return;
    drawColorFilter(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void drawColorFilter(Canvas canvas) {
    var paint = Paint();

    paint.colorFilter = ColorFilter.linearToSrgbGamma();
    _drawImage(canvas, paint, move: false);

    paint.colorFilter = ColorFilter.mode(Colors.yellow, BlendMode.modulate);
    _drawImage(canvas, paint);

    paint.colorFilter = ColorFilter.mode(Colors.yellow, BlendMode.difference);
    _drawImage(canvas, paint);

    paint.colorFilter = ColorFilter.mode(Colors.blue, BlendMode.plus);
    _drawImage(canvas, paint);

    paint.colorFilter = ColorFilter.mode(Colors.blue, BlendMode.lighten);
    _drawImage(canvas, paint);
  }

  void _drawImage(Canvas canvas, Paint paint, {bool move = true}) {
    if (move) {
      canvas.translate(120, 0);
    } else {
      canvas.translate(20, 20);
    }
    double imWidth = img?.width.toDouble() ?? 0;
    double imHeight = img?.height.toDouble() ?? 0;

    canvas.drawImageRect(img!, Rect.fromLTRB(0, 0, imWidth, imHeight),
        Rect.fromLTRB(0, 0, imWidth / 2, imHeight / 2), paint);
  }
}
