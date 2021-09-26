import 'package:and_flutter/route/PassArgumnets.dart';
import 'package:flutter/material.dart';

class SeconsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    // 接收上个页面传递的数据
    final ArgumnetData data = ModalRoute.of(context)!.settings.arguments as ArgumnetData;
  print('PageSecond: I get data from firstpage: $data');

    return Scaffold(
      appBar: AppBar(
        title: Text("SecondPage"),
      ),
      body: ElevatedButton(
        child: Text('Go Back'),
        onPressed: (){
          //Navigator.pop(context);
          // 返回数据给上一个页面
          Navigator.pop(context, ArgumnetData('return data to firstPage'));
        },
      ),
    );
  }
}