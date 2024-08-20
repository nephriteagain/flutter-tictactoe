import 'package:flutter/material.dart';
import 'package:tic_tac_toe/main.dart';

class Box extends StatelessWidget {
  final int index;
  final BoxState value;
  final void Function({required int index}) move;

  const Box({
    super.key,
    required this.index,
    required this.value,
    required this.move,
  });

  String _getValue(BoxState state) {
    if (state == BoxState.none) {
      return "";
    } else if (state == BoxState.o) {
      return "O";
    } else {
      return "X";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        move(index: index);
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: Center(
          child: Text(
            _getValue(value),
            style: TextStyle(
                fontSize: 24,
                color: value == BoxState.x ? Colors.blue : Colors.red),
          ),
        ),
      ),
    );
  }
}
