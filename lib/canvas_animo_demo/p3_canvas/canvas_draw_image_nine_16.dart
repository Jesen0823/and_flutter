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

  runApp(Paper30());
}

////////////////////////////////////////
/// drawImageNine 中主要是两个矩形域，center 和 dst。
// center 表示从资源图片image上一块可缩放的矩形域，所以原点是图片的左上角。
// dst 表示将抠出的图片填充到画布的哪个矩形域中，所以原点是画布原点。
// 这样很容易画出气泡的效果，即指定区域进行缩放，其余不动。
////////////////////////////////////////
class Paper30 extends StatefulWidget {
  const Paper30({Key? key}) : super(key: key);

  @override
  State<Paper30> createState() => _Paper30State();
}

class _Paper30State extends State<Paper30> {
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
        painter: Paper30Painter(_image),
      ),
    );
  }

  void _loadImage() async{
    _image = await loadImageFromAssets("assets/images/2ar.9.png");
    setState((){});
  }

  Future<ui.Image>? loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }
}


class Paper30Painter extends CustomPainter {
  final CommonCoordinate coordinate = CommonCoordinate();
  late Paint _paint;

  final ui.Image? image;

  Paper30Painter(this.image) {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..color = Colors.blue;

  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);
    _drawImageNine(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => image!=oldDelegate;

  void _drawImageNine(Canvas canvas) {
    if (image != null) {
      canvas.drawImageNine(
          image!,
          Rect.fromCenter(
              center: Offset(image!.width / 2, image!.height - 6.0),
              width: image!.width - 20.0,
              height: 2.0),
          Rect.fromCenter(
              center: Offset(
                0,
                0,
              ),
              width: 300,
              height: 120),
          _paint);

      canvas.drawImageNine(
          image!,
          Rect.fromCenter(
              center: Offset(image!.width / 2, image!.height - 6.0),
              width: image!.width - 20.0,
              height: 2.0),
          Rect.fromCenter(
              center: Offset(
                0,
                0,
              ),
              width: 100,
              height: 50)
              .translate(250, 0),
          _paint);

      canvas.drawImageNine(
          image!,
          Rect.fromCenter(
              center: Offset(image!.width / 2, image!.height - 6.0),
              width: image!.width - 20.0,
              height: 2.0),
          Rect.fromCenter(
              center: Offset(
                0,
                0,
              ),
              width: 80,
              height: 250)
              .translate(-250, 0),
          _paint);
    }
  }


}
