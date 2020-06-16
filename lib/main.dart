import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'Flutter Tic Tac Toe'),
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
  final cellCtrls = List<CellCtrl>.generate(9, (_) => CellCtrl());
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "X: ${scoreMap["X"]}",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Table(
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
                          controller: cellCtrls[i * 3 + j],
                          size: 100, //TODO: use dynamic size
                          onMarked: (String _mark) {
                            var index = i * 3 + j;
                            // freeCells.remove(index);
                            markCount++;
                            markMap[_mark].add(index);
                            _checkGameStatus();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              "O: ${scoreMap["O"]}",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkGameStatus() {
    if (markCount > 4) {
      _checkWin();
    }
    if (markCount == 9) {
      _endGame("It's a tie!");
    }
  }

  void _checkWin() {
    winSets.forEach((winSet) {
      markMap.keys.forEach((mark) {
        if (markMap[mark].containsAll(winSet)) {
          winSet.forEach((index) {
            cellCtrls[index].highlight();
          });
          setState(() {
            scoreMap[mark]++;
          });
          _endGame("The winner is: $mark");
        }
      });
    });
  }

  void _endGame(String message) {
    markMap.forEach((key, value) {
      value.clear();
    });
    markCount = 0;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Game Over"),
        content: Text(message),
        actions: [
          FlatButton(onPressed: _replayGame, child: Text("Replay")),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _replayGame() {
    // clear all cells
    cellCtrls.forEach((controler) {
      controler.clear();
    });
    Navigator.of(context).pop();
  }
}

class Cell extends StatefulWidget {
  final double size;
  final Function(String) onMarked;
  final CellCtrl controller;

  Cell({
    this.size,
    this.onMarked,
    this.controller,
  });

  @override
  _CellState createState() => _CellState(controller);
}

class _CellState extends State<Cell> {
  static String _mark = "O";
  bool _marked = false;
  bool _highlighted = false;

  _CellState(CellCtrl controller) {
    controller.clear = _clearMark;
    controller.highlight = _highlightMark;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: GestureDetector(
        onTap: () {
          if (_marked == false) {
            setState(() {
              _marked = true;
              _mark = (_mark == "X") ? "O" : "X";
            });
            widget.onMarked(_mark);
          }
        },
        child: _marked
            ? Center(
                child: Text(
                  _mark,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: _highlighted ? FontWeight.bold : null,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : null,
      ),
    );
  }

  void _clearMark() {
    setState(() {
      _marked = false;
      _highlighted = false;
    });
  }

  void _highlightMark() {
    setState(() {
      _highlighted = true;
    });
  }
}

class CellCtrl {
  void Function() clear;
  void Function() highlight;
}
