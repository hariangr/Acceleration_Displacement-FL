import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int startTime;
  double speed = 0;
  bool isRunning = false;
  DateTime lastTime;

  String _text = '';

  void _incrementCounter() {
    if (isRunning) {
      // If running, stop
      isRunning = false;
      startTime = null;
    } else {
      // If not running, start
      isRunning = true;
      startTime = DateTime.now().millisecondsSinceEpoch;
    }

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      if (!isRunning) {
        return;
      }

      // var curTime = DateTime.now().millisecondsSinceEpoch;

      var _curTime = DateTime.now();
      var deltaTime = _curTime.difference(lastTime);
      var elapsedSinceStarted = DateTime.now().toIso8601String();
      speed += (event.x / deltaTime.inMilliseconds);

      print("$elapsedSinceStarted\t${event.x}\t${event.y}\t${event.z}");

      setState(() {
        _text = speed.toStringAsPrecision(5).toString();
        // _text = 'aaaa';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_text',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
