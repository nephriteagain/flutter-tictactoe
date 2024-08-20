import 'package:flutter/material.dart';
import 'package:tic_tac_toe/src/box.dart';
import 'package:tic_tac_toe/src/player_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tic Tac Toe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum PlayerTurn { p1, p2 }

enum BoxState { none, x, o }

class _MyHomePageState extends State<MyHomePage> {
  List<BoxState> board = [
    BoxState.none,
    BoxState.none,
    BoxState.none,
    BoxState.none,
    BoxState.none,
    BoxState.none,
    BoxState.none,
    BoxState.none,
    BoxState.none
  ];
  PlayerTurn playerTurn = PlayerTurn.p1;
  bool isGameOver = false;

  void play() {
    setState(() {
      board = [
        BoxState.none,
        BoxState.none,
        BoxState.none,
        BoxState.none,
        BoxState.none,
        BoxState.none,
        BoxState.none,
        BoxState.none,
        BoxState.none
      ];
      playerTurn = PlayerTurn.p1;
    });
  }

  void move({required int index}) {
    BoxState selected = board[index];
    if (selected != BoxState.none) {
      return;
    }
    setState(() {
      BoxState box = playerTurn == PlayerTurn.p1 ? BoxState.x : BoxState.o;
      board[index] = box;
      bool isWinner = winnerChecker(playerTurn);
      if (isWinner) {
        _showWinnerDialog(context, playerTurn);
      }
      playerTurn = playerTurn == PlayerTurn.p1 ? PlayerTurn.p2 : PlayerTurn.p1;
    });
  }

  String getValue(BoxState state) {
    if (state == BoxState.none) {
      return "";
    } else if (state == BoxState.o) {
      return "O";
    } else {
      return "X";
    }
  }

  bool winnerChecker(PlayerTurn currentPlayer) {
    List<List<int>> winnerCombination = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    List<int> playerMoves = [];
    board.asMap().entries.forEach((entry) {
      int i = entry.key;
      BoxState v = entry.value;
      // for player 1
      if (v == BoxState.x && playerTurn == PlayerTurn.p1) {
        playerMoves.add(i);
        // for player 2
      } else if (v == BoxState.o && playerTurn == PlayerTurn.p2) {
        playerMoves.add(i);
      }
    });
    bool hasMatch = winnerCombination
        .any((values) => values.every((v) => playerMoves.any((m) => m == v)));
    if (hasMatch) {
      return true;
    }
    return false;
  }

  void _showWinnerDialog(BuildContext context, PlayerTurn winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Player ${winner == PlayerTurn.p1 ? "X" : "O"} wins!"),
          actions: <Widget>[
            TextButton(
              child: const Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Play Again"),
              onPressed: () {
                play();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          play();
        },
        child: const Text("Play"),
      ),
      body: Center(
          child: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlayerIndicator(
              playerTurn: playerTurn,
            ),
            Wrap(
              children: board.asMap().entries.map((entry) {
                int index = entry.key;
                BoxState value = entry.value;
                return Box(
                  index: index,
                  value: value,
                  move: move,
                );
              }).toList(),
            ),
          ],
        ),
      )),
    );
  }
}
