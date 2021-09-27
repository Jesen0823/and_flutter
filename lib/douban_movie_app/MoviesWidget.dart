import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoviesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MoviesWidgetState();
  }
}

class MoviesWidgetState extends State<MoviesWidget> {

  // Android调用Flutter，更新Flutter的UI
  static const platformChannel = const MethodChannel('and_flutter.test/Android2Flutter');
  String textContent = '电影[in flutter]';

  @override
  void initState() {
    super.initState();

    // 添加监听，如果被Android改动数据，用state更新数据
    platformChannel.setMethodCallHandler((call) async{
      switch(call.method){
        case 'changeText':
          String content = await call.arguments['content'];
          if(context.toString().isNotEmpty){
            setState(() {
              textContent = content;
              print("movie initState, textContent: $textContent");
            });
            return 'Success';
          }else{
            throw PlatformException(
                code: '-2',
                message: 'changeText fail',
                details: 'content is null'
            );
          }
        default:
        // 方法未实现
          throw MissingPluginException();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 80,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
                hintText: '\uE8b6 电影 / 电视剧 / 影人',
                hintStyle: TextStyle(fontFamily: 'MaterialIcons', fontSize: 16),
                contentPadding: EdgeInsets.only(top: 8, bottom: 8),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                filled: true,
                fillColor: Colors.black12),
          ),
        ),
        Expanded(
          flex: 1,
          child: DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints.expand(height: 50),
                    child: TabBar(
                        unselectedLabelColor: Colors.black12,
                        labelColor: Colors.black87,
                        indicatorColor: Colors.black87,
                        tabs: <Widget>[Tab(text: '电影'), Tab(text: '电视')]),
                  ),
                  Expanded(
                    child: Container(
                      child: TabBarView(
                        children: <Widget>[
                          Center(
                            child: Text(textContent),
                          ),
                          Center(
                            child: Text('电影'),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        )
      ],
    );
  }
}
