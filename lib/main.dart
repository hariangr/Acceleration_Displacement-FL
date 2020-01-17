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
  DateTime startTime;
  double speed = 0;
  bool isRunning = false;
  DateTime lastTime;
  double displacement = 0;

  bool first = true;

  String _text = '';

  void _incrementCounter() {
    if (isRunning) {
      // If running, stop
      isRunning = false;
      startTime = null;
      first = true;
    } else {
      // If not running, start
      speed = 0;
      displacement = 0;
      isRunning = true;
    }

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      if (first) {
        first = false;
        startTime = DateTime.now();
      }
      if (!isRunning) {
        return;
      }

      // var curTime = DateTime.now().millisecondsSinceEpoch;

      DateTime _curTime = DateTime.now();
      // var deltaTime = _curTime.difference(lastTime);
      var elapsedSinceStarted =
          "${_curTime.hour}:${_curTime.minute}:${_curTime.second}:${_curTime.millisecond}";
      var elapsedMilis = _curTime.difference(startTime).inMilliseconds;
      // var elapsedSinceStarted = _curTime.difference(startTime).inMilliseconds;

      var accX = event.x.toStringAsFixed(16).replaceAll(".", ",");
      var accY = event.y.toStringAsFixed(16).replaceAll(".", ",");
      var accZ = event.z.toStringAsFixed(16).replaceAll(".", ",");

      speed += double.parse(event.x.toStringAsFixed(8));
      displacement += speed;

      print("$elapsedSinceStarted\t$elapsedMilis\t$accX\t$accY\t$accZ\t$speed\t$displacement");

      setState(() {
        _text =
            "X" + "\n" + event.x.toStringAsFixed(8) + "\n" + speed.toStringAsPrecision(5).toString() + "\n" + displacement.toString();
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
