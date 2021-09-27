import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MineWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MineWidgetState();
  }
}

class MineWidgetState extends State<MineWidget> {
  // Flutter调用Android的Api
  static const methodChannel = const MethodChannel('and_flutter/flutter2Android');

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomScrollView(
      physics: ClampingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.card_giftcard),
              onPressed: () {
                // 此处flutter调用Android，弹出Toast
                showToast('flutter调用Android的Toast');
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // 此处flutter调用Android，弹出Dialog
                methodChannel.invokeMethod('appSetting', '尊敬的用户，设置页面暂时关闭');
              },
            )
          ],
          flexibleSpace: FlexibleSpaceBar(
            title: Text('data'),
          ),
          expandedHeight: 140,
          pinned: true,
          floating: true,
          snap: true,
        ),
        SliverFillRemaining(
          child: DefaultTabController(
              length: 6,
              child: Column(
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints.expand(height: 50),
                    child: TabBar(
                        unselectedLabelColor: Colors.black12,
                        labelColor: Colors.black87,
                        indicatorColor: Colors.black87,
                        tabs: <Widget>[
                          Tab(text: '讨论'),
                          Tab(text: '想看'),
                          Tab(text: '再看'),
                          Tab(text: '看过'),
                          Tab(text: '影评'),
                          Tab(text: '影人')
                        ]),
                  ),
                  Expanded(
                    child: Container(
                      child: TabBarView(
                        children: <Widget>[
                          Center(
                            child: Text('讨论'),
                          ),
                          Center(
                            child: Text('想看'),
                          ),
                          Center(
                            child: Text('再看'),
                          ),
                          Center(
                            child: Text('看过'),
                          ),
                          Center(
                            child: Text('影评'),
                          ),
                          Center(
                            child: Text('影人'),
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

  /// 调用Android方法弹出Toast 封装
  /// 为了不阻塞 UI，PlatformChannel 使⽤ async 和 await
  void showToast(String content) async {
    // arguments 是参数，只能是Map或者JSON类型，这⾥是Map 类型
    var arguments = Map();
    arguments['content'] = content;
    try {
      String result = await methodChannel.invokeMethod('toast', arguments);
      //success
      print('showToast ' + result);
    } on PlatformException catch (e) {
      //error
      print('showToast ' + e.code + e.message! + e.details);
    } on MissingPluginException catch (e) {
      //notImplemented
      print('showToast ' + e.message!);
    }
  }
}
