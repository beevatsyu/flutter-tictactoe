import 'package:flutter/material.dart';
import 'package:flutter_tictactoe/result.dart';
import 'package:flutter_tictactoe/score.dart';

import 'cell.dart';

class Game extends StatefulWidget {
  final ScoreCtrl scoreCtrl;
  final List<CellCtrl> cellCtrls;
  final ResultCtrl resultCtrl;

  Game(this.scoreCtrl, this.cellCtrls, this.resultCtrl);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  final winSets = const [
    {0, 1, 2},
    {3, 4, 5},
    {6, 7, 8},
    {0, 3, 6},
    {1, 4, 7},
    {2, 5, 8},
    {0, 4, 8},
    {2, 4, 6},
  ];
  final markMap = {
    "X": Set<int>(),
    "O": Set<int>(),
  };
  final scoreMap = {
    "X": 0,
    "O": 0,
  };

  int markCount = 0;

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth: IntrinsicColumnWidth(),
      border: TableBorder(
        horizontalInside: BorderSide(),
        verticalInside: BorderSide(),
      ),
      children: [
        ...List<TableRow>.generate(
          3,
          (i) => TableRow(
            children: [
              ...List<Cell>.generate(
                3,
                (j) => Cell(
                    controller: widget.cellCtrls[i * 3 + j],
                    size: 100, //TODO: use dynamic size
                    onMarked: (String _mark) {
                      _checkGameStatus(_mark, i * 3 + j);
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _checkGameStatus(String _mark, int index) {
    markCount++;
    markMap[_mark].add(index);
    if (markCount > 4) {
      winSets.forEach((winSet) {
        markMap.keys.forEach((mark) {
          if (markMap[mark].containsAll(winSet)) {
            winSet.forEach((index) {
              widget.cellCtrls[index].highlight();
            });
            widget.scoreCtrl.update(mark);
            _endGame("The winner is: $mark");
          }
        });
      });
    }
    if (markCount == 9) {
      _endGame("It's a tie!");
    }
  }

  void _endGame(String message) {
    markMap.forEach((key, value) {
      value.clear();
    });
    markCount = 0;
    widget.cellCtrls.forEach((ctrl) {
      if (!ctrl.marked) ctrl.freeze();
    });
    widget.resultCtrl.setResult(message);
  }
}
