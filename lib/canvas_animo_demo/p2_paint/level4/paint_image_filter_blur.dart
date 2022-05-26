import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

///图片滤镜imageFilter
// 可以通过 ImageFilter.blur 来让图片模糊，
// 或通过 ImageFilter.matrix 进行变换
void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(Paper13());
}

//////////////////////////////////////////////
class Paper13 extends StatefulWidget {
  const Paper13({Key? key}) : super(key: key);

  @override
  State<Paper13> createState() => _Paper13State();
}

class _Paper13State extends State<Paper13> {
  ui.Image? _img;

  bool get hasImage => _img != null;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    _loadImage();

    super.initState();
  }

  void _loadImage() async {
    _img = await loadImageFromAssets("assets/images/advert_.jpg");
    setState(() {});
  }

  Future<ui.Image> loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: hasImage
          ? CustomPaint(
              painter: Paper13Painter(_img),
            )
          : Container(),
    );
  }
}

class Paper13Painter extends CustomPainter {
  ui.Image? img;

  Paper13Painter(this.img);

  @override
  void paint(Canvas canvas, Size size) {
    if(img!=null){
      drawImageFilter(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void drawImageFilter(Canvas canvas) {
    var paint =Paint();
    //_drawImage(0,canvas,paint,move:false);

    /*paint.imageFilter = ui.ImageFilter.blur(sigmaX: 0.4,sigmaY: 0.4);
    _drawImage(1,canvas, paint);

    paint.imageFilter = ui.ImageFilter.blur(sigmaX: 0.6,sigmaY: 0.6);
    _drawImage(2,canvas, paint);*/

    paint.imageFilter = ui.ImageFilter.blur(sigmaX: 0.8,sigmaY: 0.8);
    _drawImage(3,canvas, paint);

    paint.imageFilter = ui.ImageFilter.matrix(Matrix4.skew(pi/8, 0).storage);
    _drawImage(4,canvas, paint);

    paint.imageFilter = ui.ImageFilter.matrix(Matrix4.skewX(0.8).storage);
    _drawImage(5,canvas, paint);
  }

  void _drawImage(int index,Canvas canvas, Paint paint, { bool move=true}) {
    if(move){
        canvas.translate(160,0);
    }else{
      canvas.translate(20,20);
    }
    var width = img?.width.toDouble()??0;
    var height =img?.height.toDouble()??0;

    canvas.drawImageRect(img!, Rect.fromLTRB(0, 0, width, height),
        Rect.fromLTRB(0, 0, width/2, height/2), paint);
  }

}
