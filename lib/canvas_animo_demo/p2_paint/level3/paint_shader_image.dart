import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

/// Shader之 扫描渐变着色器
void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(Paper7());
}

class Paper7 extends StatefulWidget {
  const Paper7({Key? key}) : super(key: key);

  @override
  State<Paper7> createState() => _Paper7State();
}

class _Paper7State extends State<Paper7> {
  ui.Image? _img;

  bool get hasImage => _img != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          hasImage
              ? CustomPaint(
            painter: ImageShaderPainter(_img),
          )
              : Container(),
          Image.asset('assets/images/advert_.jpg',width: 180,height: 180,)
        ],
      )
    );
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _loadImage();
    super.initState();
  }

  Future<void> _loadImage() async {
    _img = await loadImage(AssetImage('assets/images/advert_.jpg'));
    setState((){});
  }

  late ImageStreamListener listener;

  Future<ui.Image> loadImage(ImageProvider provider) {
    Completer<ui.Image> completer = Completer<ui.Image>();
    ImageStream stream = provider.resolve(ImageConfiguration());
    listener = ImageStreamListener((image, synchronousCall) {
      final ui.Image img = image.image;
      completer.complete(img);
      stream.removeListener(listener);
    });
    stream.addListener(listener);
    return completer.future;
  }
}

class ImageShaderPainter extends CustomPainter {
  ui.Image? img;
  late Paint _paint;

  ImageShaderPainter(this.img) {
    _paint = Paint();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (img == null) return;
    _paint.shader = ImageShader(
      img!,
      TileMode.repeated,
      TileMode.repeated,
      Float64List.fromList([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]),
    );

    canvas.drawCircle(Offset(100, 100), 60, _paint);
    canvas.drawCircle(
        Offset(100 + 130.0, 100),
        60,
        _paint
          ..strokeWidth = 10
          ..style = PaintingStyle.stroke);
    canvas.drawLine(
        Offset(100 + 130.0 * 2, 60),
        Offset(100 + 130.0 * 2, 60 + 100.0),
        _paint
          ..strokeWidth = 30
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
