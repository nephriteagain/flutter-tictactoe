import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tic Tac Toe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    move(index: 0);
                  },
                  child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1)),
                      child: Center(
                          child: Text(
                        getValue(board[0]),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ))),
                ),
                GestureDetector(
                  onTap: () {
                    move(index: 1);
                  },
                  child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1)),
                      child: Center(
                          child: Text(
                        getValue(board[1]),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ))),
                ),
                GestureDetector(
                  onTap: () {
                    move(index: 2);
                  },
                  child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1)),
                      child: Center(
                          child: Text(
                        getValue(board[2]),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ))),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    move(index: 3);
                  },
                  child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1)),
                      child: Center(
                          child: Text(
                        getValue(board[3]),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ))),
                ),
                GestureDetector(
                  onTap: () {
                    move(index: 4);
                  },
                  child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1)),
                      child: Center(
                          child: Text(
                        getValue(board[4]),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ))),
                ),
                GestureDetector(
                  onTap: () {
                    move(index: 5);
                  },
                  child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1)),
                      child: Center(
                          child: Text(
                        getValue(board[5]),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ))),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    move(index: 6);
                  },
                  child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1)),
                      child: Center(
                          child: Text(
                        getValue(board[6]),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ))),
                ),
                GestureDetector(
                  onTap: () {
                    move(index: 7);
                  },
                  child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1)),
                      child: Center(
                          child: Text(
                        getValue(board[7]),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ))),
                ),
                GestureDetector(
                  onTap: () {
                    move(index: 8);
                  },
                  child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1)),
                      child: Center(
                          child: Text(
                        getValue(board[8]),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ))),
                ),
              ],
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
