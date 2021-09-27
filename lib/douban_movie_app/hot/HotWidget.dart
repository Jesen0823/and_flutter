import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Doubanmain.dart';
import 'list/HotMoviesListWidget.dart';

class HotWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HotWidgetState();
  }
}

class HotWidgetState extends State<HotWidget> {

  String curCity = '上海';

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if (ShareDataInheritedWidget.of(context)!.curCity.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 80,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                GestureDetector(
                  child: Text(
                    curCity,
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    _jumpToCitysWidget();
                  },
                ),
                Icon(Icons.arrow_drop_down),
                Expanded(
                    flex: 1,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          hintText: '\uE8b6 电影 / 电视剧 / 影人',
                          hintStyle: TextStyle(
                              fontFamily: 'MaterialIcons', fontSize: 16),
                          contentPadding: EdgeInsets.only(top: 8, bottom: 8),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          filled: true,
                          fillColor: Colors.black12),
                    )),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      constraints: BoxConstraints.expand(height: 50),
                      child: TabBar(
                          unselectedLabelColor: Colors.black12,
                          labelColor: Colors.black87,
                          indicatorColor: Colors.black87,
                          tabs: <Widget>[Tab(text: '正在热映'), Tab(text: '即将上映')]),
                    ),
                    Expanded(
                        child: Container(
                      child: TabBarView(
                        physics: ClampingScrollPhysics(),
                        children: <Widget>[
                          HotMoviesListWidget(curCity),
                          Center(
                            child: Text('即将上映'),
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ))
        ],
      );
    } else {
      return Center(
        //child: CircularProgressIndicator(),
        child: Text('加载中..'),
      );
    }
  }

  void _jumpToCitysWidget() async {
    var selectCity =
        await Navigator.pushNamed(context, '/Citys',
            arguments: ShareDataInheritedWidget.of(context)!.curCity);
    if (selectCity == null) return;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('curCity', selectCity.toString()); //存取数据

    setState(() {
      /// 使用 InheritedWidget 是无法做到的，因为 InheritedWidget 只能把数据在
      /// Widget 树中向下传递，下面的数据是无法向上传递，所以下面 `curCity` 的变化，
      /// 无法通知到 InheritedWidget
      ShareDataInheritedWidget.of(context)!.curCity = selectCity.toString();
    });
  }
}
