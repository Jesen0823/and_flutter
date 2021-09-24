import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


main() => runApp(new ShowCupertinoAlertDialogWidget());

class ShowCupertinoAlertDialogWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Test',
      home: new Scaffold(
        appBar: new AppBar(
          title: Text('ios 风格的对话框'),
        ),
        body: Builder(
          builder: (context){
            return ElevatedButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: Text('CupertinoAlertDialog'),
                      actions: [
                        CupertinoDialogAction(
                            child: Text('OK'),
                          onPressed: (){
                              Navigator.of(context).pop();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text('cancel'),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  );
                },
                child: Text('ios dialog')
            );
          },
        ),
      ),
    );
  }
}