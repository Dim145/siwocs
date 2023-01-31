import 'package:audioplayers/audioplayers.dart';
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
  int _counter = 1;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final player = AudioCache(prefix: "assets/sounds/");

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  void _incrementCounter() async {
    final url = await player.load("$_counter.wav");
    _audioPlayer.stop();
    _audioPlayer.setUrl(url.path, isLocal:true);
    _audioPlayer.resume();
    setState(() {
      _counter = _counter%4 + 1;
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
        painter: SiwocsPainter(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SiwocsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;

    var width = size.width;
    var height = size.height;

    final paint = Paint()
      ..strokeWidth = 5
      ..color = Colors.indigoAccent
      ..style = PaintingStyle.stroke;

    var circleRadius = size.width / 2 - size.width/3;
    var circleCenter = Offset(width / 2, height / 2);
    canvas.drawCircle(circleCenter, circleRadius, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}