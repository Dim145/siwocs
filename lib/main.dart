import 'dart:math';

import 'package:flutter/material.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Siwocs game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: CustomPaint(
        painter: SiwocsPainter(),
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
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
  ];


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
      paint.color = colors[i];

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