import 'package:flutter/material.dart';
import 'package:flutter_tictactoe/game.dart';
import 'package:flutter_tictactoe/result.dart';

import 'cell.dart';
import 'score.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  final cellCtrls = List<CellCtrl>.generate(9, (_) => CellCtrl());
  final scoreCtrl = ScoreCtrl();
  final resultCtrl = ResultCtrl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Score(scoreCtrl),
            Game(scoreCtrl, cellCtrls, resultCtrl),
            Result(cellCtrls, resultCtrl),
          ],
        ),
      ),
    );
  }
}
