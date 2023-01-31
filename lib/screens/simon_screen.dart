import 'package:flutter/material.dart';
import 'dart:math';

class SimonGame {

  SimonGame() {
    levelUp();
  }

  final Random _random = Random();

  final List<int> _sequence = [];
  int _position = 0;

  void levelUp() {
    _sequence.add(_random.nextInt(4));
  }

  void error() {

  }

  void play(int input) {
    print('playing $input');

    if (_sequence[_position] != input) {
      _position = 0;
      return;
    }

    _position++;

    if (_position == _sequence.length) {
      levelUp();
      _position = 0;
    }
  }

  getSequence() {
    return _sequence;
  }
}
