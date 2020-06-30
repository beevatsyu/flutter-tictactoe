import 'dart:math';

import 'package:flutter/material.dart';
import 'result.dart';
import 'score.dart';
import 'cell.dart';

class Game extends StatefulWidget {
  final ScoreCtrl scoreCtrl;
  final List<CellCtrl> cellCtrls;
  final ResultCtrl resultCtrl;
  final GameCtrl gameCtrl;

  Game({this.scoreCtrl, this.cellCtrls, this.resultCtrl, this.gameCtrl});

  @override
  _GameState createState() => _GameState(gameCtrl);
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

  int markCount = 0;

  _GameState(GameCtrl ctrl) {
    ctrl.reset = _resetGame;
    ctrl.end = _endGame;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = min(constraints.maxHeight, constraints.maxWidth) * 0.25;
        return Table(
          defaultColumnWidth: IntrinsicColumnWidth(),
          border: TableBorder(
            horizontalInside: BorderSide(),
            verticalInside: BorderSide(),
          ),
          children: [
            ...List<TableRow>.generate(
              3,
              (row) => TableRow(
                children: [
                  ...List<Cell>.generate(
                    3,
                    (col) {
                      var index = row * 3 + col;
                      return Cell(
                        size: cellSize,
                        controller: widget.cellCtrls[index],
                        onMarked: (mark) => _checkGameStatus(mark, index),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _checkGameStatus(String _mark, int index) {
    markCount++;
    markMap[_mark].add(index);
    if (markCount > 4) {
      for (var winSet in winSets) {
        for (var mark in markMap.keys) {
          if (markMap[mark].containsAll(winSet)) {
            winSet.forEach((index) => widget.cellCtrls[index].highlight());
            widget.scoreCtrl.update(mark);
            _endGame("The winner is: $mark");
            return;
          }
        }
      }
    }
    if (markCount == 9) {
      _endGame("It's a tie!");
      return;
    }
  }

  void _endGame(String message) {
    // Freeze unmarked cells
    widget.cellCtrls.forEach((ctrl) {
      if (!ctrl.marked) {
        ctrl.freeze();
      }
    });
    // Display result: win/tie
    widget.resultCtrl.setResult(message);
  }

  void _resetGame() {
    // Reset all cells
    widget.cellCtrls.forEach((ctrl) {
      ctrl.reset();
      ctrl.marked = false;
    });
    // Reset game progress
    markMap.forEach((key, value) {
      value.clear();
    });
    markCount = 0;
  }
}

class GameCtrl {
  Function() reset;
  Function(String) end;
}
