import 'dart:ui' as ui;
import 'package:and_flutter/canvas_animo_demo/common_coordinate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;

void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(Paper03());
}

class Paper03 extends StatefulWidget {
  const Paper03({Key? key}) : super(key: key);

  @override
  State<Paper03> createState() => _Paper03State();
}

class _Paper03State extends State<Paper03> {
  image.Image? _image;
  List<Ball> balls = [];
  double d = 8;

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
        painter: Paper03Painter(balls,_image),
      ),
    );
  }

  void _loadImage() async {
    _image = await loadImageFromAssets("assets/images/2z#-s.png");
    if (_image == null) return;
    for (int i = 0; i < _image!.width; i++) {
      for (int j = 0; j < _image!.height; j++) {
        Ball ball = Ball();
        ball.x = i * d + d / 2;
        ball.y = j * d + d / 2;
        ball.r = d / 2;
        var color = Color(_image!.getPixel(i, j));
        ball.color =
            Color.fromARGB(color.alpha, color.blue, color.green, color.red);
        balls.add(ball);
      }
    }
    setState(() {});
  }

  Future<image.Image?> loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return image.decodeImage(data.buffer.asUint8List());
  }
}

class Paper03Painter extends CustomPainter {
  late Paint _paint;
  late image.Image? img;
  final double strokeWidth = 0.5;
  final Color color = Colors.blue;

  final List<Ball> balls;
  final CommonCoordinate coordinate = CommonCoordinate();

  Paper03Painter(this.balls, image.Image? image) {
    img=image;
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth
      ..color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //
    coordinate.paint(canvas, size);
    canvas.translate(20, 8);
    _drawImage(canvas);
    canvas.drawRect(Rect.fromPoints(
        Offset(0,0),
        Offset(img?.width.toDouble()??0,img?.height.toDouble()??0)
    ), _paint..style=PaintingStyle.stroke..color=Colors.green..strokeWidth=2);
  }

  @override
  bool shouldRepaint(Paper03Painter oldDelegate) => balls != oldDelegate.balls;

  void _drawImage(Canvas canvas) {
    balls.forEach((Ball ball) {
      canvas.drawCircle(
          Offset(ball.x, ball.y), ball.r, _paint..color = ball.color);
    });
  }
}

class Ball {
  double x;
  double y;
  Color color;
  double r;

  Ball({this.x = 0, this.y = 0, this.color = Colors.black, this.r = 2});
}
