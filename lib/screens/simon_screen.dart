import 'package:flutter/material.dart';
import 'dart:math';

class SimonSays extends StatefulWidget {
  final String title;

  const SimonSays({super.key, required this.title});

  @override
  State<SimonSays> createState() => _SimonSaysState();
}

class _SimonSaysState extends State<SimonSays> {

  _SimonSaysState() {
    levelUp();
  }

  final Random _random = Random();

  final List<int> _sequence = [];
  int _position = 0;

  Simon() {
    levelUp();
  }

  void levelUp() {
    _sequence.add(_random.nextInt(4));
  }

  void error() {

  }

  void play(int input) {
    print('playing $input');
    setState(() {
      if (_sequence[_position] != input) {
        _position = 0;
        return;
      }

      _position++;

      if (_position == _sequence.length) {
        levelUp();
        _position = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_sequence.join(', ')),
            Text("Position: $_position"),
            ElevatedButton(onPressed: (){play(0);}, child: const Text("Rouge (0)")),
            ElevatedButton(onPressed: (){play(1);}, child: const Text("Jaune (1)")),
            ElevatedButton(onPressed: (){play(2);}, child: const Text("Bleu (2)")),
            ElevatedButton(onPressed: (){play(3);}, child: const Text("Vert (3)")),
          ],
        ),
      ),
    );
  }
}
