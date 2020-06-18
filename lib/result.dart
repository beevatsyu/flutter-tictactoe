import 'package:flutter/material.dart';
import 'game.dart';
import 'cell.dart';

class Result extends StatefulWidget {
  final List<CellCtrl> cellCtrls;
  final ResultCtrl resultCtrl;
  final GameCtrl gameCtrl;

  Result({this.cellCtrls, this.resultCtrl, this.gameCtrl});

  @override
  _ResultState createState() => _ResultState(resultCtrl);
}

class _ResultState extends State<Result> {
  String result = "";

  _ResultState(ResultCtrl ctrl) {
    ctrl.setResult = (result) => setState(() => this.result = result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            result,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        RaisedButton.icon(
          onPressed: () {
            setState(() => result = "");
            widget.gameCtrl.reset();
          },
          icon: Icon(Icons.replay),
          label: Text("Replay"),
        ),
      ],
    );
  }
}

class ResultCtrl {
  Function(String) setResult;
}
