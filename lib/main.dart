import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game.dart';
import 'result.dart';
import 'cell.dart';
import 'score.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatelessWidget {
  final cellCtrls = List<CellCtrl>.generate(9, (i) => CellCtrl(i));
  final scoreCtrl = ScoreCtrl();
  final gameCtrl = GameCtrl();
  final resultCtrl = ResultCtrl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Score(scoreCtrl),
            Game(
              scoreCtrl: scoreCtrl,
              gameCtrl: gameCtrl,
              cellCtrls: cellCtrls,
              resultCtrl: resultCtrl,
            ),
            Result(
              resultCtrl: resultCtrl,
              gameCtrl: gameCtrl,
            ),
          ],
        ),
      ),
    );
  }
}
