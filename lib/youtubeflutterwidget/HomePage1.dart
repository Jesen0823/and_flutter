import 'package:flutter/material.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({Key? key,required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    var title;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Stepper(
          steps: const [
            Step(
              title: Text('Step 01'),
              content: Text('Information for step1'),
            ),
            Step(
              title: Text('Step 02'),
              content: Text('Information for step2'),
            ),
            Step(
              title: Text('Step 03'),
              content: Text('Information for step3'),
            ),
            Step(
              title: Text('Step 04'),
              content: Text('Information for step4'),
            ),
            Step(
              title: Text('Step 05'),
              content: Text('Information for step5'),
            ),
          ],
          onStepTapped: (int newIndex) {
            setState(() {
              _currentStep = newIndex;
            });
          },
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep != 2) {
              setState(() {
                _currentStep += 1;
              });
            }
          },
          onStepCancel: () {
            if (_currentStep != 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
        ),
      ),
    );
  }
}
