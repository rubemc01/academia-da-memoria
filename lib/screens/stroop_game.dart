import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class StroopGame extends StatefulWidget {
  @override
  _StroopGameState createState() => _StroopGameState();
}

class _StroopGameState extends State<StroopGame> {
  final Map<String, Color> _colors = {
    'VERMELHO': Colors.red,
    'AZUL': Colors.blue,
    'VERDE': Colors.green,
    'AMARELO': Colors.amber,
    'ROXO': Colors.purple,
  };

  String _word = "";
  Color _color = Colors.black;
  bool _isMatch = false;
  int _score = 0;
  int _timeLeft = 0;
  int _totalTime = 3000;
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
      _isPlaying = true;
      _nextRound();
    });
  }

  void _nextRound() {
    _timer?.cancel();
    Random rnd = Random();
    List<String> keys = _colors.keys.toList();
    bool shouldMatch = rnd.nextBool();

    String randomWord = keys[rnd.nextInt(keys.length)];
    Color randomColor;

    if (shouldMatch) {
      randomColor = _colors[randomWord]!;
      _isMatch = true;
    } else {
      List<String> otherKeys = List.from(keys)..remove(randomWord);
      String otherColorName = otherKeys[rnd.nextInt(otherKeys.length)];
      randomColor = _colors[otherColorName]!;
      _isMatch = false;
    }

    setState(() {
      _word = randomWord;
      _color = randomColor;
      _timeLeft = _totalTime;
    });

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _timeLeft -= 10;
      });
      if (_timeLeft <= 0) {
        _gameOver();
      }
    });
  }

  void _handleAnswer(bool userAnswer) {
    if (!_isPlaying) return;

    if (userAnswer == _isMatch) {
      setState(() {
        _score++;
        if (_totalTime > 1000) _totalTime -= 50;
      });
      _nextRound();
    } else {
      _gameOver();
    }
  }

  void _gameOver() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Fim de Jogo!"),
        content: Text("Você fez $_score pontos."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _totalTime = 3000);
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
        title: Text(
          'Desafio das Cores',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isPlaying) ...[
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.palette, size: 80, color: Colors.redAccent),
                ),
                SizedBox(height: 30),
                Text(
                  "A cor do texto combina com a palavra escrita?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    "COMEÇAR",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ] else ...[
                Text(
                  "Pontos: $_score",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 20),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _timeLeft / _totalTime,
                    color: _timeLeft < 1000 ? Colors.red : Colors.blue,
                    backgroundColor: Colors.grey[200],
                    minHeight: 15,
                  ),
                ),
                Spacer(),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "A cor é igual à palavra?",
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _word,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: _color,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleAnswer(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                        ),
                        child: Icon(Icons.check, size: 50),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleAnswer(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                        ),
                        child: Icon(Icons.close, size: 50),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
