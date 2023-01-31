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
  final player = AudioCache(prefix: "assets/sounds/");

  void _incrementCounter() async {
    int tmpc = _counter + 1;
    final url = await player.load("$tmpc.wav");

    _audioPlayer.stop();
    _audioPlayer.setUrl(url.path, isLocal:true);
    _audioPlayer.resume();

    Test(5);
  }

  void Test(int i) {
    if(i <= 0) {
      return;
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _counter = Random().nextInt(4);
      });

      Test(i - 1);
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
  static const colors = [
    [Colors.red, Colors.redAccent],
    [Colors.green, Colors.greenAccent],
    [Colors.yellow, Colors.yellowAccent],
    [Colors.blue, Colors.blueAccent],
  ];

  int _counter = -1;

  SiwocsPainter(int counter) {
    _counter = counter;
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
      paint.color = colors[i][_counter == i ? 1 : 0];

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