import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class NumbersGame extends StatefulWidget {
  @override
  _NumbersGameState createState() => _NumbersGameState();
}

class _NumbersGameState extends State<NumbersGame> {
  String _currentNumber = "";
  int _level = 3;
  bool _isShowingNumber = false;
  bool _isInputVisible = false;
  final TextEditingController _controller = TextEditingController();

  void _startGame() {
    setState(() {
      _level = 3;
      _nextRound();
    });
  }

  void _nextRound() {
    int min = pow(10, _level - 1).toInt();
    int max = pow(10, _level).toInt() - 1;

    setState(() {
      _currentNumber = (min + Random().nextInt(max - min)).toString();
      _isShowingNumber = true;
      _isInputVisible = false;
      _controller.clear();
    });

    Timer(Duration(seconds: 2), () {
      setState(() {
        _isShowingNumber = false;
        _isInputVisible = true;
      });
    });
  }

  void _checkAnswer() {
    if (_controller.text == _currentNumber) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Correto!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() => _level++);
      Future.delayed(Duration(seconds: 1), _nextRound);
    } else {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Fim de Jogo"),
        content: Text(
          "O número era $_currentNumber.\nVocê chegou ao nível $_level.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: Text("Tentar Novamente"),
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
          'Flash Numérico',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isShowingNumber && !_isInputVisible) ...[
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(Icons.looks_5, size: 60, color: Colors.green),
                ),
                SizedBox(height: 30),
                Text(
                  "Memorize o número que vai aparecer.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _startGame,
                  child: Text("COMEÇAR", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],

              if (_isShowingNumber) ...[
                Text(
                  "Memorize!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  _currentNumber,
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 2,
                  ),
                ),
              ],

              if (_isInputVisible) ...[
                Text(
                  "Qual era o número?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    letterSpacing: 5,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                  ),
                  onSubmitted: (_) => _checkAnswer(),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _checkAnswer,
                    child: Text("VERIFICAR", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
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
