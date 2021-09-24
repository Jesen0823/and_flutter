import 'package:flutter/material.dart';

main() => runApp(new PersistentBottomSheetWidgetWidget());

class PersistentBottomSheetWidgetWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Test',
      home: new Scaffold(
        appBar: new AppBar(title: Text('PersistentBottomSheet'),),
        body: Builder(
          builder: (context){
            return ElevatedButton(
                onPressed: (){}, 
                child: Text('showBottomSheet'),
            );
          },
        ),
        bottomSheet: BottomSheet(
          onClosing: (){},
          builder: (context) => Container(
            height: 200.0,
            color: Colors.blueAccent,
            child: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('dismiss'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}