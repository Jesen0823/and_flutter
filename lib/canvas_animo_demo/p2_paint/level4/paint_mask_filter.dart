import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
/// 遮罩滤镜maskFilter
// 使图片进行模糊，可以指定模糊的类型, 只有一个 MaskFilter.blur 构造
void main(){
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(Paper12());
}

//////////////////////////////////////////////
class Paper12 extends StatefulWidget {
  const Paper12({Key? key}) : super(key: key);

  @override
  State<Paper12> createState() => _Paper12State();
}

class _Paper12State extends State<Paper12> {
  ui.Image? _img;
  bool get hasImage => _img!=null;


  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: hasImage ? CustomPaint(
        painter: Paper12Painter(_img) ,
      ): Container(),
    );
  }
}


class Paper12Painter extends CustomPainter{

  ui.Image? img;

  Paper12Painter(this.img);

  @override
  void paint(Canvas canvas, Size size) {
    if(img!=null){
      drawMaskFilter(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>true;

  void drawMaskFilter(Canvas canvas) {
    var paint = Paint();
    paint..color=Colors.red;

    _drawImage(canvas, paint,move: false);

    paint.maskFilter=MaskFilter.blur(BlurStyle.inner, 20);
    _drawImage(canvas, paint);

    paint.maskFilter=MaskFilter.blur(BlurStyle.outer, 20);
    _drawImage(canvas, paint);

    paint.maskFilter=MaskFilter.blur(BlurStyle.solid, 20);
    _drawImage(canvas, paint);

    paint.maskFilter=MaskFilter.blur(BlurStyle.normal, 20);
    _drawImage(canvas, paint);
  }

  void _drawImage(Canvas canvas,Paint paint,{bool move=true}){
    var width = (img?.width.toDouble()??0)*0.6;
    var height = (img?.height.toDouble()??0*0.6);

    if(move){
      canvas.translate(120,0);
    }else{
      canvas.translate(20, 20);
    }
    canvas.drawImageRect(img!, Rect.fromLTRB(0, 0, width, height),
        Rect.fromLTRB(0, 0, width/2, height/2), paint);

  }
}