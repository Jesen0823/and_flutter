import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

///  ColorFilter.matrix 颜色矩阵变换
void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(Paper11());
}

class Paper11 extends StatefulWidget {
  const Paper11({Key? key}) : super(key: key);

  @override
  State<Paper11> createState() => _Paper11State();
}

class _Paper11State extends State<Paper11> {
  ui.Image? _img;
  bool get hasImage => _img!=null;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: hasImage ? CustomPaint(
        painter: Paper11Painter(_img) ,
      ): Container(),
    );
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    _loadImage();
    super.initState();
  }

  void _loadImage() async{
    _img = await loadImageFromAssets("assets/images/advert_.jpg");
    setState((){});
  }

  Future<ui.Image>loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }
}


class Paper11Painter extends CustomPainter{
  ui.Image? img;

  Paper11Painter(this.img);

  @override
  void paint(Canvas canvas, Size size) {
    if(img!=null){
      drawColorFilter(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>true;

  void drawColorFilter(Canvas canvas) {
    var paint =Paint();
    const ColorFilter identity = ColorFilter.matrix(<double>[
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0,
    ]);
    _drawImage(canvas, paint..colorFilter=identity,move: false);

    const ColorFilter sepia = ColorFilter.matrix(<double>[
      0.393, 0.769, 0.189, 0, 0,
      0.349, 0.686, 0.168, 0, 0,
      0.272, 0.534, 0.131, 0 , 0,
      0,     0,     0,     1, 0,
    ]);
    _drawImage(canvas, paint..colorFilter=sepia);

    const ColorFilter invert = ColorFilter.matrix(<double>[
      -1,  0,  0, 0, 255,
      0, -1,  0, 0, 255,
      0,  0, -1, 0, 255,
      0,  0,  0, 1,   0,
    ]);
    _drawImage(canvas, paint..colorFilter=invert);

    const ColorFilter greyscale = ColorFilter.matrix(<double>[
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0,      0,      0,      1, 0,
    ]);
    _drawImage(canvas, paint..colorFilter=greyscale);

    const n = 90.0;
    const ColorFilter light = ColorFilter.matrix(<double>[
      1,0,0,0,n,
      0,1,0,0,n,
      0,0,1,0,n,
      0,0,0,1,0
    ]);
    _drawImage(canvas, paint..colorFilter=light);
  }

  void _drawImage(Canvas canvas, Paint paint,{bool move=true}) {
    if(move){
      canvas.translate(120, 0);
    }else{
      canvas.translate(20, 20);
    }
    double width = img?.width.toDouble()?? 0;
    double height = img?.height.toDouble()??0;
    canvas.drawImageRect(img!,
        Rect.fromLTRB(0, 0, width, height),
        Rect.fromLTRB(0, 0, width/2, height/2),
        paint);
  }

}