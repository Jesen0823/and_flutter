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

  runApp(Paper28());
}

////////////////////////////////////////
/// 绘制图片
////////////////////////////////////////
class Paper28 extends StatefulWidget {
  const Paper28({Key? key}) : super(key: key);

  @override
  State<Paper28> createState() => _Paper28State();
}

class _Paper28State extends State<Paper28> {
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
        painter: Paper28Painter(_image),
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


class Paper28Painter extends CustomPainter {
  final CommonCoordinate coordinate = CommonCoordinate();
  late Paint _paint;

  final ui.Image? image;

  Paper28Painter(this.image) {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..color = Colors.blue;

  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);
    _drawImage(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => image!=oldDelegate;

  void _drawImage(Canvas canvas) {
    if (image != null) {
      canvas.drawImage(
          image!, Offset(-image!.width / 2, -image!.height / 2), _paint);
    }
  }
}
