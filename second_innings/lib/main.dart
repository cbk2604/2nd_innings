import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '2nd Innings'),
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
  Random randomScore = new Random();
  int _counter = 0;
  int _minScore = 30;
  int _maxScore = 90;
  List<String> _players = ["P1", "P2", "P3", "P4", "P5"];
  List<String> _bowler = ["B1", "B2", "B3", "B4", "B5"];
  List<String> _ballValue = ["0", "1", "2", "3", "4", "6", "W", "NB"];
  String _onCreaseBatsman = "P1";
  String _runnerBatsman = "P2";
  String _currentBowler = "";
  List<List<String>> _bowlersInfo = [[], [], [], [], []];
  int _numberOfWickets = 0;
  int _currentScore = 0;
  int _numberOfOvers = 0;
  int _numberOfBalls = 0;
  int _firstInningsScore = 30 + Random().nextInt(60);
  String _lastBallValue = "";
  bool _isMatchOver = false;
  bool _isWonTheMatch = false;
  bool _matchStarted = false;

  void _incrementCounter() {
    setState(() {
      int _randomValue = randomScore.nextInt(_maxScore - _minScore);
      print(_randomValue);
      _counter = _minScore + _randomValue;
    });
  }

  Widget _targetScoreBoard() {
    return Row(
      children: [
        Text(
          'Target Score:    ',
        ),
        Text(
          '$_firstInningsScore',
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }

  Widget _secondInningsScoreBoard() {
    return Row(
      children: [
        Text(
          'Score:    ',
        ),
        Text(
          '$_currentScore / $_numberOfWickets',
          style: Theme.of(context).textTheme.headline4,
        )
      ],
    );
  }

  Widget _oversBoard() {
    return Row(
      children: [
        Text('Overs:   '),
        Text(
          '$_numberOfOvers.$_numberOfBalls',
          style: Theme.of(context).textTheme.headline6,
        )
      ],
    );
  }

  Widget _onCreaseBatsmanInfo() {
    return Row(
      children: [
        Text('On Crease Batsman:  '),
        Text(
          '$_onCreaseBatsman',
          style: TextStyle(color: Colors.redAccent),
        )
      ],
    );
  }

  Widget _runnerBatsmanInfo() {
    return Row(
      children: [
        Text('Runner Batsman:  '),
        Text(
          '$_runnerBatsman',
        )
      ],
    );
  }

  void _swapBatsman() {
    String _temp = _onCreaseBatsman;
    _onCreaseBatsman = _runnerBatsman;
    _runnerBatsman = _temp;
  }

  void _lastBallValueMethod() {
    setState(() {
      if (_currentScore >= _firstInningsScore) {
        _isMatchOver = true;
        _isWonTheMatch = true;
      } else {
        if (_numberOfOvers == 5) {
          _isMatchOver = true;
          _isWonTheMatch = false;
        } else {
          int _ballValueIndex = Random().nextInt(_ballValue.length);
          _lastBallValue = _ballValue[_ballValueIndex];

          if (int.tryParse(_lastBallValue) != null) {
            _currentScore = _currentScore + int.tryParse(_lastBallValue) ?? 0;
            if (_currentScore >= _firstInningsScore) {
              _isMatchOver = true;
              _isWonTheMatch = true;
            }
          }

          if (_lastBallValue == 'W') {
            _numberOfWickets++;
            print(_numberOfWickets);
            if (_numberOfWickets + 1 == _players.length) {
              _isMatchOver = true;
              _isWonTheMatch = false;
              _onCreaseBatsman = "-";
            } else {
              _onCreaseBatsman = _players[_numberOfWickets + 1];
            }
          } else if (_lastBallValue == '1' || _lastBallValue == '3') {
            _swapBatsman();
          }

          if (_numberOfBalls < 5) {
            _numberOfBalls++;
            _bowlersInfo[_numberOfOvers].add(_lastBallValue);
          } else {
            _numberOfBalls = 0;
            _bowlersInfo[_numberOfOvers].add(_lastBallValue);
            _numberOfOvers++;
            if (_numberOfOvers != 5) {
              int _currentBowlerIndex = Random().nextInt(_bowler.length);
              _currentBowler = _bowler[_currentBowlerIndex];
              _bowler.removeAt(_currentBowlerIndex);
              _bowlersInfo[_numberOfOvers].add(_currentBowler);
            }
            if (_numberOfOvers == 5) {
              _isMatchOver = true;
              // _isWonTheMatch = false;
            }
            _swapBatsman();
          }
        }
      }
    });
  }

  Widget _lastBallResultBoard() {
    return Column(
      children: [
        Text('Last ball score'),
        Text(
          _lastBallValue,
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }

  Widget _nextBallButton() {
    String _nextBallTitle = "Next Ball";
    if (_numberOfBalls == 0 && _numberOfOvers == 0) {
      _nextBallTitle = "First Ball";
    } else if (_numberOfBalls == 5 && _numberOfOvers == 4) {
      _nextBallTitle = "Last Ball";
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FlatButton(
        onPressed: _lastBallValueMethod,
        child: Text(
          _nextBallTitle,
        ),
        color: Colors.blue,
        height: 30,
      ),
    );
  }

  Widget _matchStatus() {
    return _numberOfOvers <= 0
        ? _nextBallButton()
        : _isMatchOver
            ? _matchResultDisplay()
            : _nextBallButton();
  }

  Widget _matchResultDisplay() {
    String _resultMessage =
        _isWonTheMatch ? "You Won the Match." : "You lost the match.";
    Color _resultMessageColor = _isWonTheMatch ? Colors.green : Colors.red;
    return Column(
      children: [
        Text(
          _resultMessage,
          style: TextStyle(color: _resultMessageColor, fontSize: 30),
        ),
        SizedBox(height: 20),
        FlatButton(
            onPressed: _startNewMatch,
            child: Text(
              'Start New Match',
            ),
            color: Colors.blue,
            height: 30)
      ],
    );
  }

  void _startNewMatch() {
    setState(() {
      _matchStarted = false;
      _firstInningsScore = 30 + Random().nextInt(60);
      _numberOfWickets = 0;
      _currentScore = 0;
      _numberOfOvers = 0;
      _numberOfBalls = 0;
      _lastBallValue = "";
      _isMatchOver = false;
      _isWonTheMatch = false;
      _bowlersInfo = [[], [], [], [], []];
      _bowler = ["B1", "B2", "B3", "B4", "B5"];
      _onCreaseBatsman = "P1";
      _runnerBatsman = "P2";
      _currentBowler = "";
    });
  }

  void _letsStartTheInnings() {
    setState(() {
      _matchStarted = true;

      int _currentBowlerIndex = Random().nextInt(_bowler.length);
      _currentBowler = _bowler[_currentBowlerIndex];
      _bowler.removeAt(_currentBowlerIndex);
      _bowlersInfo[_numberOfOvers].add(_currentBowler);
    });
  }

  Row _eachBallInfoForBowler(List<String> ballInfo) {
    List<Container> _childrens = [];
    for (var _eachBallInfo in ballInfo) {
      _childrens.add(Container(
        width: 50,
        child: Text(
          '$_eachBallInfo     ',
        ),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _childrens,
    );
  }

  List<Widget> _eachBowlerInfo() {
    List<Widget> _eachBowlerList = [];
    for (var _eachBowler in _bowlersInfo) {
      _eachBowlerList.add(_eachBallInfoForBowler(_eachBowler));
      _eachBowlerList.add(SizedBox(height: 10));
    }
    return _eachBowlerList;
  }

  Widget _showBowlersInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _eachBowlerInfo(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _matchStarted
        ? Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _targetScoreBoard(),
                    SizedBox(height: 20),
                    _secondInningsScoreBoard(),
                    _oversBoard(),
                    SizedBox(height: 10),
                    _onCreaseBatsmanInfo(),
                    _runnerBatsmanInfo(),
                    SizedBox(height: 20),
                    Text(
                      'Bowlers Info',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 20),
                    _showBowlersInfo(),
                    SizedBox(height: 50),
                    _lastBallResultBoard(),
                    _matchStatus()
                  ],
                ),
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Targeted Score'),
                    Text(
                      '$_firstInningsScore',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(height: 30),
                    FlatButton(
                      onPressed: _letsStartTheInnings,
                      child: Text('Let\'s Start'),
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
