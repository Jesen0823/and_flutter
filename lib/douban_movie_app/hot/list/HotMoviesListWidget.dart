import 'dart:convert';

import 'package:and_flutter/douban_movie_app/hot/data/HotMovieData.dart';
import 'package:and_flutter/douban_movie_app/hot/item/HotMovieItemWidget.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    if(hotMovies == null || hotMovies.isEmpty){
      return Center(
        child: CircularProgressIndicator(),
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