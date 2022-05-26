import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

/// 滤镜质量filterQuality
// 一共四种类型: 表现依次如下
//
// enum FilterQuality {
//   none,
//   low,
//   medium,
//   high,
// }
void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(Paper14());
}


class Paper14 extends StatefulWidget {

  const Paper14({Key? key}) : super(key: key);

  @override
  State<Paper14> createState() => _Paper14State();
}

class _Paper14State extends State<Paper14> {
  ui.Image? _img;
  bool  get hasImage=> _img!=null;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: hasImage?CustomPaint(
        painter: Paper14Painter(_img),
      ):Container(),
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

  void _loadImage() async {
    _img = await loadImageFromAssets("assets/images/advert_.jpg");
    setState(() {});
  }

  Future<ui.Image> loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }

}

class Paper14Painter extends CustomPainter{

  ui.Image? img;

  Paper14Painter(this.img);

  @override
  void paint(Canvas canvas, Size size) {
    if(img!=null) {
      drawFilterQuality(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void drawFilterQuality(Canvas canvas) {
    var paint =Paint();
    paint.imageFilter=ui.ImageFilter.blur(sigmaX: 0.6,sigmaY: 0.6);
    paint.maskFilter=MaskFilter.blur(BlurStyle.inner, 20);
    paint.colorFilter=ColorFilter.mode(Colors.yellow, BlendMode.modulate);

    paint.filterQuality=FilterQuality.none;
    _drawImage(canvas, paint,move: false);

    paint.filterQuality=FilterQuality.low;
    _drawImage(canvas, paint);

    paint.filterQuality=FilterQuality.medium;
    _drawImage(canvas, paint);

    paint.filterQuality=FilterQuality.high;
    _drawImage(canvas, paint);
  }

  void _drawImage(Canvas canvas, Paint paint,{bool move=true}) {
    var width = img?.width.toDouble()??0;
    var height = img?.height.toDouble()??0;

    if(move){
      canvas.translate(160, 0);
    }else{
      canvas.translate(20, 20);
    }
    canvas.drawImageRect(img!,
        Rect.fromLTRB(0, 0, width, height),
        Rect.fromLTRB(0, 0, width/2, height/2),
        paint);
  }

}