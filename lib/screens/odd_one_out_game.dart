import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class OddOneOutGame extends StatefulWidget {
  @override
  _OddOneOutGameState createState() => _OddOneOutGameState();
}

class _OddOneOutGameState extends State<OddOneOutGame> {
  // Pares de (Normal, Intruso)
  final List<List<String>> _pairs = [
    ['😀', '😃'],
    ['🙂', '🙃'],
    ['🐶', '🐺'],
    ['🍎', '🍅'],
    ['🚗', '🚕'],
    ['⌚', '⏰'],
    ['⚽', '🏀'],
    ['🔐', '🔓'],
    ['☀️', '🌼'],
    ['🌚', '🌑'],
    ['👓', '🕶️'],
    ['🟥', '🟧'],
  ];

  String _mainIcon = '';
  String _oddIcon = '';
  int _oddIndex = -1;
  int _gridSize = 3; // 3x3, 4x4, etc.
  int _score = 0;
  int _timeLeft = 10;
  Timer? _timer;
  bool _isPlaying = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _timeLeft = 15; // 15 segundos iniciais
      _gridSize = 3;
      _isPlaying = true;
      _nextRound();
      _startTimer();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _gameOver();
      }
    });
  }

  void _nextRound() {
    var rng = Random();
    var pair = _pairs[rng.nextInt(_pairs.length)];

    // Deixa mais difícil a cada 3 pontos
    if (_score > 0 && _score % 3 == 0 && _gridSize < 6) {
      _gridSize++;
    }

    setState(() {
      _mainIcon = pair[0];
      _oddIcon = pair[1];
      _oddIndex = rng.nextInt(_gridSize * _gridSize);
      // Ganha um tempinho extra a cada acerto
      if (_timeLeft < 30) _timeLeft += 2;
    });
  }

  void _handleTap(int index) {
    if (index == _oddIndex) {
      setState(() => _score++);
      _nextRound();
    } else {
      // Penalidade de tempo por erro
      setState(() {
        _timeLeft = (_timeLeft - 3).clamp(0, 100);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("-3 Segundos!"),
          duration: Duration(milliseconds: 500),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _gameOver() {
    _timer?.cancel();
    setState(() => _isPlaying = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Tempo Esgotado!"),
        content: Text("Você encontrou $_score intrusos."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: Text("Jogar de Novo"),
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
        title: Text('Caça ao Intruso'),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              if (!_isPlaying) ...[
                Icon(Icons.person_search, size: 80, color: Colors.amber[800]),
                SizedBox(height: 20),
                Text(
                  "Encontre o emoji diferente antes que o tempo acabe!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[800],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text("COMEÇAR", style: TextStyle(fontSize: 20)),
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pontos: $_score",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Tempo: $_timeLeft s",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _timeLeft < 5 ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: _gridSize * _gridSize,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _gridSize,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _handleTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              index == _oddIndex ? _oddIcon : _mainIcon,
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
