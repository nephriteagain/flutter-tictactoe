import 'package:flutter/material.dart';
import 'package:tic_tac_toe/main.dart';

class PlayerIndicator extends StatelessWidget {
  final PlayerTurn playerTurn;

  const PlayerIndicator({super.key, required this.playerTurn});

  @override
  Widget build(BuildContext context) {
    return Text(
      playerTurn == PlayerTurn.p1 ? "Player X's turn" : "Player O's turn",
      style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: playerTurn == PlayerTurn.p1 ? Colors.blue : Colors.red),
    );
  }
}
