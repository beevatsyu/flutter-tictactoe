import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  final cellCtrls;
  final resultCtrl;

  Result(this.cellCtrls, this.resultCtrl);

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
        Text(result),
        RaisedButton.icon(
          onPressed: () {
            widget.cellCtrls.forEach((controler) {
              controler.reset();
            });
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