import 'package:and_flutter/canvas_animo_demo/common_coordinate.dart';
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

  runApp(Paper31());
}

////////////////////////////////////////
/// 在画布上绘制一张图片上的很多部分，比如雪碧图 (Sprite) 将需要的图片放在一张图里。
/// 另外通过 drawAtlas 绘制的效率要更高。
////////////////////////////////////////

class Paper31 extends StatefulWidget {
  @override
  _Paper31State createState() => _Paper31State();
}

class _Paper31State extends State<Paper31> {
  @override
  void initState() {
    super.initState();
    _loadImage();
  }


  void _loadImage() async {
    _image =
    await loadImageFromAssets('assets/images/2z_.png');
    setState(() {});
  }

  ui.Image? _image;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: CustomPaint(
            painter: Paper31Painter(
              _image,
            )));
  }

  //读取 assets 中的图片
  Future<ui.Image>? loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }
}

class Paper31Painter extends CustomPainter {
  late Paint _paint;

  final double strokeWidth = 0.5;
  final Color color = Colors.blue;

  final ui.Image? image;
  final CommonCoordinate coordinate = CommonCoordinate();

  final List<Sprite> allSprites = [];

  Paper31Painter(this.image) {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth
      ..color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null) {
      return;
    }
    coordinate.paint(canvas, size);

    allSprites.add(Sprite(
        position: Rect.fromLTWH(0, 325, 257, 166),
        offset: Offset(0, 0),
        alpha: 255,
        rotation: 0));

    allSprites.add(Sprite(
        position: Rect.fromLTWH(0, 325, 257, 166),
        offset: Offset(257, 130),
        alpha: 255,
        rotation: 0));

    final List<RSTransform> transforms = allSprites
        .map((sprite) => RSTransform.fromComponents(
      rotation: sprite.rotation,
      scale: 1.0,
      anchorX: sprite.anchor.dx,
      anchorY: sprite.anchor.dy,
      translateX: sprite.offset.dx,
      translateY: sprite.offset.dy,
    ))
        .toList();

    final List<Rect> rects =
    allSprites.map((sprite) => sprite.position).toList();

    canvas.drawAtlas(image!, transforms, rects, null, null, null, _paint);
  }

  @override
  bool shouldRepaint(Paper31Painter oldDelegate) => image != oldDelegate.image;
}

class Sprite {
  Rect position; // 雪碧图 中 图片矩形区域
  Offset offset; // 移动偏倚
  Offset anchor; // 移动偏倚
  int alpha; // 透明度
  double rotation; // 旋转角度

  Sprite({this.offset=Offset.zero,this.anchor=Offset.zero, this.alpha=255, this.rotation=0,required this.position});
}