import 'package:and_flutter/douban_movie_app/hot/data/HotMovieData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HotMovieItemWidget extends StatefulWidget {
  HotMovieData hotMovieData;

  HotMovieItemWidget(this.hotMovieData);

  @override
  State<StatefulWidget> createState() {
    return HotMovieItemWidgetState();
  }
}

class HotMovieItemWidgetState extends State<HotMovieItemWidget> {
  static const methodChannel = const MethodChannel('flutter.doubanmovie/buy');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            widget.hotMovieData.images!.small,
            width: 80,
            height: 120,
            fit: BoxFit.cover,
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.hotMovieData.title as String,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      widget.hotMovieData.rating!.average.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.black45),
                    ),
                    Text(
                      '导演：' + widget.hotMovieData.directors.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              )),
          Container(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.hotMovieData.collectCount.toString() + '人看过',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
                OutlinedButton(
                  child: Text(
                    '购票',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                      TextStyle(color: Colors.red),
                    ),
                    side: MaterialStateProperty.all(
                      BorderSide(color: Colors.red),
                    ),
                  ),
                  onPressed: () {
                    methodChannel.invokeMethod(
                        'buyTicket',
                        '购买 ' +
                            widget.hotMovieData.title.toString() +
                            ' 电影票一张');
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
