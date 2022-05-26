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

  runApp(Paper15());
}

//////////////////////////////////////////////
class Paper15 extends StatefulWidget {
  const Paper15({Key? key}) : super(key: key);

  @override
  State<Paper15> createState() => _Paper15State();
}

class _Paper15State extends State<Paper15> {
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
      child: hasImage ? CustomPaint(
        painter: Paper15Painter(_img) ,
      ): Container(),
    );
  }
}

class Paper15Painter extends CustomPainter{

  ui.Image? img;
  Paper15Painter(this.img);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }

}