import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class SequenceGame extends StatefulWidget {
  @override
  _SequenceGameState createState() => _SequenceGameState();
}

class _SequenceGameState extends State<SequenceGame> {
  final List<Color> _gameColors = [
    Colors.redAccent,
    Colors.greenAccent.shade700,
    Colors.blueAccent,
    Colors.amber,
  ];

  List<int> _sequence = [];
  List<int> _userSequence = [];
  int _activeColorIndex = -1;
  bool _isShowingSequence = false;
  bool _gameOver = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
  }

  void _startGame() {
    setState(() {
      _sequence = [];
      _userSequence = [];
      _score = 0;
      _gameOver = false;
      _isShowingSequence = false;
      _nextRound();
    });
  }

  void _nextRound() async {
    setState(() {
      _sequence.add(Random().nextInt(4));
      _userSequence = [];
      _isShowingSequence = true;
    });

    await Future.delayed(Duration(seconds: 1));

    for (int index in _sequence) {
      setState(() => _activeColorIndex = index);
      await Future.delayed(Duration(milliseconds: 500));
      setState(() => _activeColorIndex = -1);
      await Future.delayed(Duration(milliseconds: 300));
    }

    setState(() {
      _isShowingSequence = false;
    });
  }

  void _onButtonTap(int index) {
    if (_isShowingSequence || _gameOver || _sequence.isEmpty) return;

    setState(() => _activeColorIndex = index);
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() => _activeColorIndex = -1);
    });

    if (index == _sequence[_userSequence.length]) {
      _userSequence.add(index);
      if (_userSequence.length == _sequence.length) {
        setState(() => _score++);
        Timer(Duration(seconds: 1), _nextRound);
      }
    } else {
      setState(() {
        _gameOver = true;
      });
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Fim de Jogo!"),
        content: Text("Você alcançou o nível $_score."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: Text("Tentar de Novo"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Sair"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sequência de Cores',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placar estilizado
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _sequence.isEmpty
                      ? "Toque em Iniciar"
                      : "Nível: ${_sequence.length}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              ),
              SizedBox(height: 10),

              if (_isShowingSequence)
                Text(
                  "Observe...",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              if (!_isShowingSequence && _sequence.isNotEmpty && !_gameOver)
                Text(
                  "Sua vez!",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

              SizedBox(height: 30),

              AspectRatio(
                aspectRatio: 1,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(4, (index) {
                    return GestureDetector(
                      onTap: () => _onButtonTap(index),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: _activeColorIndex == index
                              ? _gameColors[index]
                              : _gameColors[index].withOpacity(
                                  0.2,
                                ), // Cor mais suave quando inativo
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Bem redondo
                          border: Border.all(
                            color: _activeColorIndex == index
                                ? Colors.white
                                : _gameColors[index],
                            width: _activeColorIndex == index ? 4 : 2,
                          ),
                          boxShadow: [
                            if (_activeColorIndex == index)
                              BoxShadow(
                                color: _gameColors[index].withOpacity(0.6),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 30),

              if (_sequence.isEmpty)
                ElevatedButton.icon(
                  icon: Icon(Icons.play_arrow),
                  label: Text("INICIAR"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  onPressed: _startGame,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
