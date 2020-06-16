import 'package:flutter/material.dart';

class Score extends StatefulWidget {
  final _ctrl;

  Score(this._ctrl);

  @override
  _ScoreState createState() => _ScoreState(_ctrl);
}

class _ScoreState extends State<Score> {
  var score = {
    'X': 0,
    'O': 0,
  };

  _ScoreState(ScoreCtrl ctrl) {
    ctrl.update = (String mark) => setState(() => score[mark]++);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "X: ${score['X']}",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "O: ${score['O']}",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ScoreCtrl {
  Function(String) update;
}
