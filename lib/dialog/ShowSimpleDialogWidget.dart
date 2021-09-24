import 'package:flutter/material.dart';

main() => runApp(new ShowSimpleDialogWidget());

class ShowSimpleDialogWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Test",
      home: new Scaffold(
        appBar: new AppBar(title: new Text('Test bar'),),
        body: Builder(
          builder: (context){
            return ElevatedButton(
                onPressed: (){
                  showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return SimpleDialog(
                    title: Text('SimpleDialog title'),
                    children: [
                      SimpleDialogOption(
                        child: Text('OK'),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                      SimpleDialogOption(
                        child: Text('CANCEL'),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                },
              );
            }, child: Text('showSimpleDialog'),
            );
          },
        ),
      ),
    );
  }
}