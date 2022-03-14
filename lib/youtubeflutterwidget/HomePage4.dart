import 'package:flutter/material.dart';

class HomePage4 extends StatefulWidget {
  final String title;

  const HomePage4({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage4> createState() => _HomePage4State();
}

class _HomePage4State extends State<HomePage4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Slider(value: 1, onChanged: (double newValue) {}),
            SwitchListTile.adaptive(
              value: true,
              onChanged: (bool newValue) {},
              title: const Text('Switch List Title'),
            ),
            Switch.adaptive(value: true, onChanged: (bool newValue) {}),
            Icon(Icons.adaptive.share),
            const CircularProgressIndicator.adaptive()
          ],
        ),
      ),
    );
  }
}
