import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
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
  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  int _counter = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final cache = AudioCache(prefix: "assets/sounds/");

  void _incrementCounter() {
    Test(5);
  }

  void playSound(int i) async {
    int tmpc = i;
    final url = await cache.load("$tmpc.wav");

    _audioPlayer.stop();
    _audioPlayer.setUrl(url.path, isLocal:true);
    _audioPlayer.resume();
  }

  void Test(int i) {
    if(i < 0) {
      return;
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _counter = i == 0 ? -1 : Random().nextInt(4);
      });

      if (_counter >= 0) {
        playSound(_counter + 1);
      }

      Future.delayed(const Duration(milliseconds: 700), () {
        setState(() {
          _counter = -1;
        });

        Test(i - 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: CustomPaint(
        painter: SiwocsPainter(_counter),
        key: UniqueKey(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Restart',
        child: const Icon(Icons.restart_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SiwocsPainter extends CustomPainter {
  static final colors = [
    [Colors.red, Colors.red[200]],
    [Colors.green, Colors.green[200]],
    [Colors.yellow, Colors.yellow[200]],
    [Colors.blue, Colors.blue[200]],
  ];


  int highlight = -1;

  SiwocsPainter(int counter) {
    highlight = counter;
  }


  @override
  void paint(Canvas canvas, Size size) {
    var size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;

    var width = size.width;
    var height = size.height;

    final paint = Paint()
      ..strokeWidth = 5
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // extern circle
    var circleRadius = size.width / 2 - size.width/3;
    var circleCenter = Offset(width / 2, height / 2);

    // draw 4 arcs
    for (var i = 0; i < colors.length; i++) {
      paint.color = colors[i][highlight == i ? 1 : 0]!;

      var rect = Rect.fromCircle(center: circleCenter, radius: circleRadius);
      var startAngle = pi / 2 * i;
      var sweepAngle = 2 * pi / 4;

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
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

    paint.style = PaintingStyle.stroke;
    canvas.drawCircle(circleCenter, circleRadius, paint);


    // draw "simon" text
    var textStyle = TextStyle(
      color: Colors.white,
      fontSize: circleRadius2 / 2,
    );

    var textSpan = TextSpan(
      text: 'Simon',
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