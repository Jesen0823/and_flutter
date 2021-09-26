import 'package:flutter/material.dart';

class PageB extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PageB"),
      ),
      body: ElevatedButton(
        child: Text('Go Back'),
        onPressed: (){
          Navigator.pushNamed(context,'/pageA');
        },
      ),
    );
  }
}