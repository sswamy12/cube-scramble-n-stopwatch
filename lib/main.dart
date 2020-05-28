import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

/// 0. Compute Average
/// 0. Show last 10 solves
/// 0. Retain only two buttons - Scramble and Start / Stop
/// 1. Naming convention
/// 2. Split long code into separate files and import
/// 3. Draw the widget tree
/// 4. Comment code
/// 5. Create Test cases for auto-testing
/// 6. Improve layout
/// 7. Images
/// 8. Generate AppIcon
/// 9. Improve performance

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cube Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController tb;
  String myScramble = "";
  List<String> face = ['U', 'D', 'L', 'R', 'F', 'B'];
  List<String> move = ['', '\'', '2'];
  int nScramble = 25;
  int nResultsToDisplay = 10;
  int nSolves = 0;
  /// Use Map for key value pairs of Averages
  Map myAverages = {'Average':'01:30','Best':'01:30','Avg 5':'01:30','3 of 5':'01:30','Avg 10':'01:30','10 of 12':'01:30'};
  String displayTimer = "00:00:00";
  List<String> result = ['','','','','','','','','','',''];
  int myElapsedTime = 0;
  List<int> myElapsedTimeList = new List<int>(25);

  @override
  void initState() {
    tb = new TabController(length: 2, vsync: this);
    super.initState();
    myScramble = scrambleCube(nScramble);
  }

  bool stopIsPressed = true;
  bool startIsPressed = true;
  bool scrambleIsPressed = true;
  Stopwatch myStopwatch = new Stopwatch();
  final myDuration = const Duration(seconds: 1);

  String scrambleCube(int n) {
    String s = '';
    int i, f, m, pf;
    for (i = 0; i < n; i++) {
      f = Random().nextInt(6);
      m = Random().nextInt(3);
      while (f == pf) {
        //try again if f and pf are same
        f = Random().nextInt(6);
      }
      s = s + (i%5==0? '\n' : '') + face[f] + move[m] + ' ';
      pf = f;
    }
    print('Scramble Example: U\' D2 L R\' F2 B\' U\' D2 L R\' F2 B\' U\' D2 L R\' F2 B\' U\' D2 L R\' F2 B\' ');
    print('Scramble Generated: $s');
    return s;
  }

  void startTimer() {
    Timer(myDuration, keepRunning);
  }

  // So, the second parameter of Timer should check if Stopwatch is still running and
  // start the Timer again for the same Duration!!
  // Looks like a recursive call of the Timer method.
  void keepRunning() {
    if (myStopwatch.isRunning) {
      startTimer();
    }
    setState(() {
       displayTimer = myStopwatch.elapsed.inHours.toString().padLeft(2, "0") +
          ":" +
          (myStopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
          ":" +
          (myStopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
    });
  }

  void startStopwatch() {
    setState(() {
      stopIsPressed = false;
      startIsPressed = false;
      scrambleIsPressed = false;
    });
    myStopwatch.start();
    startTimer();
  }

  void stopStopwatch() {
    setState(() {
      stopIsPressed = true;
      scrambleIsPressed = true;
    });
    myStopwatch.stop();

    result[nSolves] = nSolves.toString().padLeft(2,"0") + '   ' + displayTimer;
    print(result[nSolves]);
    nSolves++;
    if (nSolves > 9) {
      nSolves = 0;
    }
  }

  void calculateAverage() {

  }

  void scrambleButton() {
    setState(() {
      startIsPressed = true;
      scrambleIsPressed = true;
    });
    myStopwatch.reset();
    myScramble = scrambleCube(nScramble);
    displayTimer = "00:00:00";
  }

  Widget TimerTabContainer() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Center(
                        child: Text(
                          myScramble,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        displayTimer,
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ])),
          ),
          Expanded(
            flex: 4,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: stopIsPressed ? null : stopStopwatch,
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 15.0,
                        ),
                        child: Text(
                          "Stop",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: scrambleIsPressed ? scrambleButton : null,
                        color: Colors.teal,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 15.0,
                        ),
                        child: Text(
                          "Scramble",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  RaisedButton(
                    onPressed: startIsPressed ? startStopwatch : null,
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 15.0,
                    ),
                    child: Text(
                      "Start ",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget ResultTabContainer() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        result[9],
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        result[8],
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        result[7],
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ), Text(
                        result[6],
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        result[5],
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        result[4],
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ), Text(
                        result[3],
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        result[2],
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        result[1],
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),Text(
                        result[0],
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ])),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cube Timer",
        ),
        bottom: TabBar(
          tabs: <Widget>[
            Text("Timer"),
            Text("Result"),
          ],
          labelPadding: EdgeInsets.only(
            bottom: 10.0,
          ),
          labelStyle: TextStyle(
            fontSize: 25.0,
          ),
          unselectedLabelColor: Colors.white70,
          controller: tb,
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          TimerTabContainer(),
          ResultTabContainer(),
        ],
        controller: tb,
      ),
    );
  }
}
