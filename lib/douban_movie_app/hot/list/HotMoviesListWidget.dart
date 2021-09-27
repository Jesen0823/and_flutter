import 'dart:convert';

import 'package:and_flutter/douban_movie_app/hot/data/HotMovieData.dart';
import 'package:and_flutter/douban_movie_app/hot/item/HotMovieItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class HotMoviesListWidget extends StatefulWidget{
  late String curCity;

  HotMoviesListWidget(String city){
    curCity = city;
  }

  @override
  State<StatefulWidget> createState() {
    return HotMoviesListWidgetState();
  }
}

class HotMoviesListWidgetState extends State<HotMoviesListWidget>{
  List<HotMovieData> hotMovies =[];

  /// EventChannel 只能 从 Android 向 Flutter 发送数据，它的使⽤⽅式很像我们熟悉的 Event 的使⽤⽅式
  static const eventChannel = const EventChannel('and_flutter.hot/event');
  String textContent = '空';

  @override
  void initState() {
    super.initState();
    _getData();
    // EventChannel设置监听
    eventChannel.receiveBroadcastStream().listen(_onListen, onDone: _onDone, cancelOnError: false);
  }

  void _onListen(dynamic data) {
    setState(() {
      textContent = data;
    });
  }

  void _onError() {
    setState(() {
      textContent = 'EventChannel error';
    });
  }

  void _onDone() {
    setState(() {
      textContent = 'EventChannel done';
    });
  }

  @override
  Widget build(BuildContext context) {
    if(hotMovies == null || hotMovies.isEmpty){
      return Center(
        //child: CircularProgressIndicator(),
        child: Text(textContent),
      );
    }else{
      return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView.separated(
          itemCount: hotMovies.length,
          itemBuilder: (context, index) {
            return HotMovieItemWidget(hotMovies[index]);
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              color: Colors.black26,
            );
          },
        ),
      );
    }
  }

  void _getData() async{
    List<HotMovieData> serverDataList = [];
    var response = await http.get(
        'https://api.douban.com/v2/movie/in_theaters?apikey=0b2bdeda43b5688921839c8ecb20399b&city=' +
            widget.curCity +
            '&start=0&count=10');

    if(response.statusCode == 200){
      var responseJson = json.decode(response.body);
      for(dynamic data in responseJson['subjects']){
        HotMovieData hotMovieData = HotMovieData.fromJson(data);
        serverDataList.add(hotMovieData);
      }

      setState(() {
        hotMovies = serverDataList;
      });
    }
  }

  bool get wantKeepAlive => true; //返回 true，表示不会被回收
}