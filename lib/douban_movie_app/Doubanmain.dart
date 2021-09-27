import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CitysWidget.dart';
import 'MineWidget.dart';
import 'MoviesWidget.dart';
import 'hot/HotWidget.dart';

/**通过 InheritedWidget 对豆瓣电影 App 的重构，我们可以发现 InheritedWidget 的优点：

* 可以对全局状态进行管理

但是，也有很多的缺点：

* UI 逻辑和业务逻辑没有分开
* 无法管理本地状态
* 数据只能从上到下传递，无法从下到上传递
* 随着 App 变大，代码维护也会变得越来越难。

所以，不要使用 InheritedWidget 对状态进行管理。*/

main() async {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      checkerboardOffscreenLayers: true, //使⽤了 saveLayer的图像会显示为棋盘格式并随着⻚⾯刷新⽽闪烁
      checkerboardRasterCacheImages: true, // 做了缓 存的静态图像图⽚在刷新⻚⾯使不会改变棋盘格的颜⾊；如果棋盘 格颜⾊变了，说明被重新缓存，这是我们要避免的

      title: 'Fluter Douban',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MyHomePage(title: '豆瓣电影',key: Key('douban'),),
      routes: {
        '/Citys': (context) => CitysWidget(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget{
  final String title;

  MyHomePage({required Key key, required this.title}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }

}

class _MyHomePageState extends State<MyHomePage>{

  int _selectedIndex = 0;
  late String _curCity;

  final _widgetItems = [HotWidget(), MoviesWidget(), MineWidget()];

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async{
    final prefs = await SharedPreferences.getInstance(); //获取 prefs

    String city = prefs.getString('curCity'); //获取 key 为 curCity 的值

    if (city != null && city.isNotEmpty) {
      //如果有值
      setState(() {
        _curCity = city;
      });
    } else {
      //如果没有值，则使用默认值
      setState(() {
        _curCity = '深圳';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShareDataInheritedWidget(
        _curCity,
      child: _widgetItems[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.sailing), label: '热映'),
          BottomNavigationBarItem(icon: Icon(Icons.find_in_page),label: '找片'),
          BottomNavigationBarItem(icon: Icon(Icons.wallpaper),label: '我的'),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.pink,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped (int index){
    setState(() {
      _selectedIndex = index;
    });
  }

}

/// 定义 InheritedWidget 管理存储全局数据，即全局城市state
class ShareDataInheritedWidget extends InheritedWidget{

  String curCity;

  ShareDataInheritedWidget(this.curCity, {required Widget child}) : super(child: child);

  //定义一个方法，方便子树中的 Widget 获取 ShareDataInheritedWidget 实例
  static ShareDataInheritedWidget? of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<ShareDataInheritedWidget>();
  }

  /// 判断需不需要通知依赖 InheritedWidget 数据的子 Widget
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return (oldWidget as ShareDataInheritedWidget).curCity != curCity;
  }

}
