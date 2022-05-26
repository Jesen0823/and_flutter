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

  runApp(Paper29());
}

////////////////////////////////////////
/// drawImageRect中主要是两个矩形域，src 和 dst。
// src 表示从资源图片 image 上抠出一块矩形域，所以原点是图片的左上角。
// dst 表示将抠出的图片填充到画布的哪个矩形域中，所以原点是画布原点。
////////////////////////////////////////
class Paper29 extends StatefulWidget {
  const Paper29({Key? key}) : super(key: key);

  @override
  State<Paper29> createState() => _Paper29State();
}

class _Paper29State extends State<Paper29> {
  ui.Image? _image;


  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper29Painter(_image),
      ),
    );
  }

  void _loadImage() async{
    _image = await loadImageFromAssets("assets/images/advert_.jpg");
    setState((){});
  }

  Future<ui.Image>? loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }
}


class Paper29Painter extends CustomPainter {
  final CommonCoordinate coordinate = CommonCoordinate();
  late Paint _paint;

  final ui.Image? image;

  Paper29Painter(this.image) {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..color = Colors.blue;

  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);
    _drawImagRecte(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => image!=oldDelegate;

  void _drawImagRecte(Canvas canvas) {
    if (image != null) {
      canvas.drawImage(
          image!, Offset(-image!.width / 2, -image!.height / 2), _paint);

      canvas.drawImageRect(
          image!,
          Rect.fromCenter(
              center: Offset(image!.width/2, image!.height/2), width: 60, height: 60),
          Rect.fromLTRB(0, 0, 100, 100).translate(200, 0),
          _paint);

      canvas.drawImageRect(
          image!,
          Rect.fromCenter(
              center: Offset(image!.width/2, image!.height/2-60), width: 60, height: 60),
          Rect.fromLTRB(0, 0, 100, 100).translate(-280, -100),
          _paint);

      canvas.drawImageRect(
          image!,
          Rect.fromCenter(
              center: Offset(image!.width/2+60, image!.height/2), width: 60, height: 60),
          Rect.fromLTRB(0, 0, 100, 100).translate(-280, 50),
          _paint);
    }
  }
}
