import 'package:flutter/material.dart';
import 'package:sync/sync.dart';

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
  static String globalMark = "X";
  String localMark;
  static final lock = Mutex();
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
      frozen = true;
    };
    controller.highlight = () => setState(() {
          highlighted = true;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: GestureDetector(
        onTap: () async {
          await lock.acquire();
          debugPrint(DateTime.now().toString());
          try {
            if (!marked && !frozen) {
              setState(() {
                marked = true;
                localMark = globalMark;
              });
              globalMark = flip(globalMark);
              widget.controller.marked = true;
              CellCtrl.nextMark = globalMark;
              widget.onMarked(localMark);
            }
          } catch (e) {
            debugPrint(e);
          } finally {
            lock.release();
          }
        },
        child: marked
            ? FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    localMark,
                    style: TextStyle(
                      color: highlighted ? Colors.red : null,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

String flip(String mark) => (mark == "X") ? "O" : "X";

class CellCtrl {
  final int index;
  bool marked = false;
  static String nextMark = _CellState.globalMark;
  void Function() reset;
  void Function() freeze;
  void Function() highlight;

  CellCtrl(this.index);
}
