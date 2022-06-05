import 'dart:ui' as ui;
import 'package:and_flutter/canvas_animo_demo/common_coordinate.dart';
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

class Paper02 extends StatefulWidget {
  const Paper02({Key? key}) : super(key: key);

  @override
  State<Paper02> createState() => _Paper02State();
}

class _Paper02State extends State<Paper02> {
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
        painter: Paper02Painter(_image),
      ),
    );
  }

  void _loadImage() async {
    _image = await loadImageFromAssets("assets/images/2z#.png");
    setState(() {});
  }

  Future<ui.Image>? loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }
}

class Paper02Painter extends CustomPainter {
  static const double step = 20;
  final ui.Image? image;

  Paper02Painter(this.image);

  final List<Color> colors = List<Color>.generate(
      256, (index) => Color.fromARGB(255 - index, 255, 0, 0));
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    //
    if(image ==null) return;

    Paint srcPaint = Paint();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.translate(-step * 17, -step * 7);
    Paint dstPaint = Paint();
    BlendMode.values.asMap().forEach((i, value) {
      int line = i ~/ 10;
      int row = i % 10;
      canvas.save();

      canvas.translate(3.7 * step * row, 5.5 * step * line);
      canvas.drawImageRect(image!, Rect.fromPoints(Offset.zero, Offset(image!.width*1.0,image!.height*1.0)),
          Rect.fromCenter(center:Offset.zero, width: 25*2.0,height: 25*2.0), dstPaint);

      srcPaint
        ..color = Color(0xffff0000)
        ..blendMode = value;
      canvas.drawRect(
          Rect.fromPoints(Offset.zero, Offset(20 * 2.0, 20 * 2.0)), srcPaint);

      _simpleDrawText(canvas,value.toString().split(".")[1],offset: Offset(-10, 50));
      canvas.restore();
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void _simpleDrawText(Canvas canvas, String str,
      {Offset offset = Offset.zero, Color color = Colors.black}) {
    var builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.left,
      fontSize: 12,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    ))
      ..pushStyle(
        ui.TextStyle(color: color, textBaseline: ui.TextBaseline.alphabetic),
      )
      ..addText(str);

    canvas.drawParagraph(
        builder.build()
          ..layout(ui.ParagraphConstraints(width: 12.0 * str.length)),
        offset);
  }
}
