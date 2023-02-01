import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:siwocs/simon_logic.dart';
import 'package:siwocs/siwocs_painter.dart';
import 'package:touchable/touchable.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Siwocs game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = -1;
  bool _sequencePlaying = false;

  int _score = 0;
  int _delaySpeed = 500;

  late AudioPlayer _audioPlayer;
  late SimonGame simonGame;

  _MyHomePageState() {
    simonGame = SimonGame();
    _audioPlayer = AudioPlayer();

    Future.delayed(const Duration(seconds: 1), playSequence);
  }

  playSound(String sound) async {
    try {
      await _audioPlayer.setAsset("assets/sounds/$sound.wav");
      await _audioPlayer.play();
    } catch (e) {
      print("Erreur lors de la lecture du son : $e");
    }
  }

  playSequence() async {
    _sequencePlaying = true;
    for (var i = 0; i < simonGame.getSequence().length; i++) {
      await Future.delayed(Duration(milliseconds: _delaySpeed));

      _counter = simonGame.getSequence()[i];
      playSound("${_counter+1}");

      setState(() {});

      await Future.delayed(Duration(milliseconds: _delaySpeed));
      setState(() {_counter = -1;});
    }
    _sequencePlaying = false;
  }

  @override
  Widget build(BuildContext context) {
    return CanvasTouchDetector(
      builder: (context) => CustomPaint(
        painter: SiwocsPainter(context, _counter, _score, touchCallback),
      ),
      key: UniqueKey(),
      gesturesToOverride: const [GestureType.onTapDown],
    );
  }

  touchCallback(counter) async {
    if(_sequencePlaying) return;

    var res = simonGame.play(counter);

    setState(() {
      _counter = counter;
    });

    if(res == 1) {
      _sequencePlaying = true;
      playSound("correct");
      setState(() {
        _score++;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if(_delaySpeed > 100) {_delaySpeed -= 25;}
        playSequence();
      });
    }
    else if (res == -1 )
    {
      _sequencePlaying = true;
      playSound("error");
      Future.delayed(const Duration(milliseconds: 500), () {
        playSequence();
      });
    } else {
      playSound("${_counter+1}");
    }
  }
}