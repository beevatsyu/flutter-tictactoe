import 'package:flutter/material.dart';

class Cell extends StatefulWidget {
  final double size;
  final int position;
  final Function(String) onMarked;
  final CellCtrl controller;

  Cell({
    this.size,
    this.position,
    this.onMarked,
    this.controller,
  });

  @override
  _CellState createState() => _CellState(controller);
}

class _CellState extends State<Cell> {
  static String mark = "O";
  bool marked = false;
  bool frozen = false;
  bool highlighted = false;

  _CellState(CellCtrl controller) {
    controller.reset = () => setState(() {
          marked = false;
          frozen = false;
          highlighted = false;
        });
    controller.freeze = () {
      debugPrint("Cell ${widget.position}: frozen");
      frozen = true;
    };
    controller.highlight = () => setState(() {
          highlighted = true;
        });
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.index = widget.position;
    return Container(
      width: widget.size,
      height: widget.size,
      child: GestureDetector(
        onTap: () {
          if (!marked && !frozen) {
            debugPrint("Cell ${widget.position}: onTap()");
            setState(() {
              marked = true;
              mark = (mark == "X") ? "O" : "X";
            });
            widget.controller.marked = true;
            widget.onMarked(mark);
          }
        },
        child: marked
            ? Center(
                child: Text(
                  mark,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: highlighted ? FontWeight.bold : null,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : null,
      ),
    );
  }
}

class CellCtrl {
  int index;
  bool marked = false;
  void Function() reset;
  void Function() freeze;
  void Function() highlight;
}
