import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../score_manager.dart'; // Para salvar o recorde

class MathGame extends StatefulWidget {
  @override
  _MathGameState createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> with TickerProviderStateMixin {
  String _equation = "";
  int _result = 0;
  String _userAnswer = ""; // O que o usuário digitou

  int _score = 0;
  int _timeLeft = 30;
  int _totalTime = 30; // Para a barra de progresso
  Timer? _timer;
  bool _isPlaying = false;

  // Animação de cor quando acerta/erra
  Color _backgroundColor = Colors.grey[50]!;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _timeLeft = 30;
      _totalTime = 30;
      _userAnswer = "";
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
    // Dificuldade progressiva
    int maxNum = 10 + (_score * 2);

    int a = rng.nextInt(maxNum) + 1;
    int b = rng.nextInt(maxNum) + 1;

    // 0: Soma, 1: Subtração, 2: Multiplicação (só números pequenos)
    int operation = rng.nextInt(3);

    setState(() {
      _userAnswer = ""; // Limpa a resposta anterior

      if (operation == 0) {
        _equation = "$a + $b";
        _result = a + b;
      } else if (operation == 1) {
        // Garante positivo
        if (a < b) {
          int temp = a;
          a = b;
          b = temp;
        }
        _equation = "$a - $b";
        _result = a - b;
      } else {
        // Multiplicação (mantém números menores para não ficar impossível de cabeça)
        a = rng.nextInt(9) + 2; // 2 a 10
        b = rng.nextInt(9) + 2;
        _equation = "$a × $b";
        _result = a * b;
      }
    });
  }

  // Função chamada pelos botões do nosso teclado
  void _onKeyTap(String value) {
    if (!_isPlaying) return;

    setState(() {
      if (value == 'DEL') {
        if (_userAnswer.isNotEmpty) {
          _userAnswer = _userAnswer.substring(0, _userAnswer.length - 1);
        }
      } else {
        if (_userAnswer.length < 4) {
          // Limite de caracteres
          _userAnswer += value;
        }
      }
    });

    // Verifica automaticamente se acertou (sem precisar apertar Enter)
    if (_userAnswer.isNotEmpty && int.tryParse(_userAnswer) == _result) {
      _handleCorrectAnswer();
    }
  }

  void _handleCorrectAnswer() {
    setState(() {
      _score++;
      _timeLeft += 2; // Bônus de tempo!
      if (_timeLeft > _totalTime)
        _timeLeft = _totalTime; // Não ultrapassa o máximo
      _backgroundColor = Colors.green.withOpacity(0.2); // Pisca verde
    });

    // Volta a cor normal depois de 100ms
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) setState(() => _backgroundColor = Colors.grey[50]!);
    });

    _nextRound();
  }

  void _gameOver() {
    _timer?.cancel();
    ScoreManager.updateScore('math', _score); // Salva o recorde

    setState(() => _isPlaying = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(Icons.timer_off, size: 50, color: Colors.teal),
            SizedBox(height: 10),
            Text("Tempo Esgotado!"),
          ],
        ),
        content: Text(
          "Você resolveu $_score equações.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: Text("Jogar Novamente"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha Dialog
              Navigator.pop(context); // Fecha Tela
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
        title: Text('Matemática Veloz'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: _backgroundColor, // Fundo animado
      body: Column(
        children: [
          // --- ÁREA DE JOGO (TOPO) ---
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isPlaying) ...[
                    Icon(
                      Icons.calculate_outlined,
                      size: 80,
                      color: Colors.teal,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Resolva rápido para ganhar tempo!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _startGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        "COMEÇAR",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ] else ...[
                    // Barra de Tempo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _timeLeft / _totalTime,
                        minHeight: 15,
                        backgroundColor: Colors.grey[300],
                        color: _timeLeft < 10 ? Colors.red : Colors.teal,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Tempo: $_timeLeft s",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Spacer(),

                    // Equação
                    Text(
                      _equation,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Resposta do Usuário (Mostra o que ele está digitando)
                    Container(
                      height: 80,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.teal.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _userAnswer.isEmpty ? "?" : _userAnswer,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Pontos: $_score",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // --- TECLADO CUSTOMIZADO (EMBAIXO) ---
          if (_isPlaying)
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(child: _buildKeyRow(['1', '2', '3'])),
                    Expanded(child: _buildKeyRow(['4', '5', '6'])),
                    Expanded(child: _buildKeyRow(['7', '8', '9'])),
                    Expanded(
                      child: _buildKeyRow(['', '0', 'DEL']),
                    ), // Espaço vazio para alinhar
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: keys.map((key) {
        if (key.isEmpty) return Expanded(child: SizedBox()); // Espaço vazio

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              onPressed: () => _onKeyTap(key),
              style: ElevatedButton.styleFrom(
                backgroundColor: key == 'DEL'
                    ? Colors.red[50]
                    : Colors.grey[100],
                foregroundColor: key == 'DEL' ? Colors.red : Colors.grey[800],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: key == 'DEL'
                  ? Icon(Icons.backspace_outlined)
                  : Text(
                      key,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
