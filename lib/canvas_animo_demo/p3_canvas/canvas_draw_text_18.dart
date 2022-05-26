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

  runApp(Paper32());
}

////////////////////////////////////////
/// 文字绘制
/// 通过 ParagraphBuilder 构造基本样式 pushStyle 和添加文字addText。
// builder.build() 可以创建 Paragraph 对象，之后必须对其排布layout 限制区域。
// 下面蓝色区域是绘制的辅助， 依次是左对齐、居中、右对齐。
///
/// TextPainter的绘制基本上就是对drawParagraph的封装，提供了更多的方法，使用起来简洁一些。
/// 所以一般来说都是使用 TextPainter 进行文字绘制。绘制先设置 TextPainter，
/// 然后执行 layout() 方法进行布局，其中可以传入布局区域的最大和最小宽度。通过 paint 方法进行绘制。
////////////////////////////////////////

class Paper32 extends StatefulWidget {
  @override
  _Paper32State createState() => _Paper32State();
}

class _Paper32State extends State<Paper32> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: Paper32Painter(),
      ),
    );
  }
}

class Paper32Painter extends CustomPainter {
  late Paint _paint;

  final double strokeWidth = 0.5;
  final Color color = Colors.blue;

  final CommonCoordinate coordinate = CommonCoordinate();

  Paper32Painter() {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth
      ..color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);
    canvas.translate(size.width / 2, size.height / 2);

    //_drawTextWithParagraph(canvas, TextAlign.start);
    //_drawTextWithParagraph(canvas,TextAlign.left);
    //_drawTextWithParagraph(canvas,TextAlign.center);
    _drawTextWithParagraph(canvas, TextAlign.right);

    canvas.save();
    canvas.translate(0, 50);
    _drawWithTextPaint(canvas);
    canvas.restore();

    _drawTextPaintShowSize(canvas);

    canvas.save();
    canvas.translate(0, 150);
    _drawTextPaintWithPaint(canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(Paper32Painter oldDelegate) => true;

  void _drawTextWithParagraph(Canvas canvas, TextAlign textAlign) {
    var builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: textAlign,
      fontSize: 40,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    ));
    builder.pushStyle(
      ui.TextStyle(
          color: Colors.black87, textBaseline: ui.TextBaseline.alphabetic),
    );
    builder.addText("用 Paragraph绘制");
    ui.Paragraph paragraph = builder.build();
    paragraph.layout(ui.ParagraphConstraints(width: 300));
    canvas.drawParagraph(paragraph, Offset(0, 0));
    canvas.drawRect(Rect.fromLTRB(0, 0, 300, 40),
        _paint..color = Colors.blue.withAlpha(33));
  }

  void _drawWithTextPaint(Canvas canvas) {
    var textPainter = TextPainter(
        text: TextSpan(
            text: '用TextPaint',
            style: TextStyle(fontSize: 40, color: Colors.green)),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);

    // 进行布局
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);
  }

  // 通过textPainter.size可以测量得到文字占用范围
  void _drawTextPaintShowSize(Canvas canvas) {
    TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: 'textPainter范围',
            style: TextStyle(
                fontSize: 40,
                color: Colors.black)),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    textPainter.layout(); // 进行布局
    Size size = textPainter.size; // 尺寸必须在布局后获取
    textPainter.paint(canvas, Offset(-size.width / 2, -size.height / 2));

    canvas.drawRect(
        Rect.fromLTRB(0, 0, size.width, size.height)
            .translate(-size.width / 2, -size.height / 2),
        _paint..color = Colors.red.withAlpha(33));
  }

  ////比如设置线型的文字，或为文字添加画笔着色器等。
  // 可以使用 TextStyle 中的 foreground 属性提供一个画笔。
  // 注意:此属性和 TextStyle#color 属性互斥
  void _drawTextPaintWithPaint(Canvas canvas) {
    var colors = [
      Color(0xFFF60C0C),
      Color(0xFFF3B913),
      Color(0xFFE7F716),
      Color(0xFF3DF30B),
      Color(0xFF0DF6EF),
      Color(0xFF08AbDB),
      Color(0xFFB709F4),
    ];

    var pos = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];

    Paint textPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    textPaint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(100, 0), colors, pos, TileMode.clamp);

    TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: 'Heiti SC foreground',
            style: TextStyle(
                foreground: textPaint, fontSize: 40)),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);

    textPainter.layout(maxWidth: 280); // 进行布局
    Size size = textPainter.size; // 尺寸必须在布局后获取
    textPainter.paint(canvas, Offset(-size.width / 2, -size.height / 2));

    canvas.drawRect(
        Rect.fromLTRB(0, 0, size.width, size.height)
            .translate(-size.width / 2, -size.height / 2),
        _paint..color = Colors.blue.withAlpha(33));
  }

}
