import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:siwocs/screens/simon_screen.dart';
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
  int _counter = 0;
  bool _sequencePlaying = true;

  int _score = 0;

  int _delaySpeed = 500;
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  final cache = AudioCache(prefix: "assets/sounds/");

  _MyHomePageState() {
    simonGame = SimonGame();
    playSequence();
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  late SimonGame simonGame;

  void playSound(String sound) async {
    try {
      final url = await cache.load("$sound.wav");

      _audioPlayer.stop();
      _audioPlayer.setUrl(url.path, isLocal:true);
      _audioPlayer.resume();
    } catch (e) {
      print("Erreur lors de la lecture du son : $e");
    }
  }

  playSequence() async {
    _sequencePlaying = true;
    for (var i = 0; i < simonGame.getSequence().length; i++) {
      await Future.delayed(Duration(milliseconds: _delaySpeed));
      setState(() {
        _counter = simonGame.getSequence()[i];
        playSound("${_counter+1}");
      });
      await Future.delayed(Duration(milliseconds: _delaySpeed));
      setState(() {_counter = -1;});
    }
    _sequencePlaying = false;
  }

  @override
  Widget build(BuildContext context) {
    return CanvasTouchDetector(
      builder: (context) => CustomPaint(
        painter: SiwocsPainter(context, _counter, _score, (counter) {
          setState(() {
            _counter = counter;

            print(_sequencePlaying);
            if(_sequencePlaying) return;
            
            var res = simonGame.play(counter);
            
            
            if(res == 1) {
              playSound("correct");
              setState(() {
                _score++;
              });
              Future.delayed(const Duration(milliseconds: 500), () {
                if(_delaySpeed > 60) _delaySpeed -= 25;
                playSequence();
              });
            }
            else if (res == -1 )
            {
              playSound("error");
              Future.delayed(const Duration(milliseconds: 500), () {
                playSequence();
              });
            } else {
              playSound("${_counter+1}");
            }
          });
        }),
      ),
      key: UniqueKey(),
      gesturesToOverride: const [GestureType.onTapDown],
    );
  }
}

class SiwocsPainter extends CustomPainter {
  static final colors = [
    [Colors.red, Colors.red[200]],
    [Colors.yellow, Colors.yellow[200]],
    [Colors.blue, Colors.blue[200]],
    [Colors.green, Colors.green[200]],
  ];

  int _counter = -1;
  BuildContext context;
  Function(int) callback;

  int score = 0;

  int highlight = -1;

  SiwocsPainter(this.context, int counter, int _score, this.callback) {
    _counter = counter;
    score = _score;
    highlight = counter;
  }


  @override
  void paint(Canvas canvas, Size size) {
    var touchCanvas = TouchyCanvas(context, canvas);

    var size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;

    var width = size.width;
    var height = size.height;

    final paint = Paint()
      ..strokeWidth = 5
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), Paint()..color = Colors.grey);

    // extern circle
    var circleRadius = width > height ? height / 2 - 10 : width / 2 - 10;
    var circleCenter = Offset(width / 2, height / 2);

    paint.style = PaintingStyle.stroke;
    canvas.drawCircle(circleCenter, circleRadius, paint);
    paint.style = PaintingStyle.fill;

    // draw 4 arcs
    for (var i = 0; i < colors.length; i++) {
      paint.color = colors[i][highlight == i ? 1 : 0]!;

      var rect = Rect.fromCircle(center: circleCenter, radius: circleRadius - 1);
      var startAngle = pi / 2 * i;
      var sweepAngle = 2 * pi / 4;

      touchCanvas.drawArc(rect, startAngle, sweepAngle, true, paint, onTapDown: (details) {
        print("event");
        callback(i);
      });
    }

    paint.color = Colors.black;

    // intern circle
    var circleRadius2 = circleRadius / 4;

    canvas.drawCircle(circleCenter, circleRadius2, paint);

    // vertical line
    var lineStart = Offset(width / 2, height / 2 - circleRadius);
    var lineEnd = Offset(width / 2, height / 2 + circleRadius);

    canvas.drawLine(lineStart, lineEnd, paint);

    // horizontal line
    var lineStart2 = Offset(width / 2 - circleRadius, height / 2);
    var lineEnd2 = Offset(width / 2 + circleRadius, height / 2);

    canvas.drawLine(lineStart2, lineEnd2, paint);

    // draw "simon" text
    var textStyle = TextStyle(
      color: Colors.white,
      fontSize: circleRadius2 / 2,
    );

    var textSpan = TextSpan(
      text: "$score",
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final offset = Offset(width / 2 - textPainter.width / 2, height / 2 - textPainter.height / 2);

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}