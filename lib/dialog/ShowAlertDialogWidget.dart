import 'package:flutter/material.dart';

main() => runApp(new ShowAlertDialogWidget());

class ShowAlertDialogWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Test',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('AlertDialog 对话框 flutter'),
        ),
        body: Builder(
          builder:(context){
            return ElevatedButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: new Text('AlertDialog'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            Text('This is an alert dialog'),
                            Text('add two options'),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: Text('OK')
                        ),
                        TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel')
                        )
                      ],
                    )
                  );
                },
                child: Text('showAlertDialog'));
          }
        ),
      ),
    );
  }
}