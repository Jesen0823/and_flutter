import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'CitysWidget.dart';
import 'MineWidget.dart';
import 'MoviesWidget.dart';
import 'hot/HotWidget.dart';

main(){
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  final _widgetItems = [HotWidget(), MoviesWidget(), MineWidget()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetItems[_selectedIndex],
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