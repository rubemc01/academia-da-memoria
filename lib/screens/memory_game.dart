import 'package:flutter/material.dart';
import 'dart:async';
import '../score_manager.dart'; // Importante para salvar o recorde

class MemoryGame extends StatefulWidget {
  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  // BANCO DE IMAGENS COMPLETO (12 Imagens estáveis do GitHub)
  final List<String> _allImages = [
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Cat.png',
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Dog.png',
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Panda.png',
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Koala.png',
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Chicken.png',
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Bear.png',
    // Imagens extras para o modo difícil
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Fox.png',
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Lion.png',
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Tiger.png',
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Monkey.png',
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Pig.png',
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Rabbit.png',
  ];

  // Configurações do Jogo
  bool _isHardMode = false; // Começa no fácil
  List<bool> _cardFlips = [];
  List<String> _gameBoard = [];
  int _previousIndex = -1;
  bool _wait = false;

  // Pontuação
  int _moves = 0; // Contador de tentativas
  int _matches = 0; // Quantos pares já achou

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _moves = 0;
      _matches = 0;
      _previousIndex = -1;
      _wait = false;

      // Define quantas imagens usar baseado na dificuldade
      int itemCount = _isHardMode ? 12 : 6;

      // Pega as imagens necessárias
      List<String> selection = _allImages.sublist(0, itemCount);

      // Duplica e embaralha
      _gameBoard = List.from(selection)..addAll(selection);
      _gameBoard.shuffle();

      _cardFlips = List.generate(_gameBoard.length, (index) => false);
    });
  }

  void _onCardTap(int index) {
    if (_cardFlips[index] || _wait || _previousIndex == index) return;

    setState(() {
      _cardFlips[index] = true;
    });

    if (_previousIndex == -1) {
      // Primeira carta do par
      _previousIndex = index;
    } else {
      // Segunda carta do par (Conta como 1 movimento)
      setState(() {
        _moves++;
      });

      if (_gameBoard[index] == _gameBoard[_previousIndex]) {
        // ACERTOU
        _matches++;
        _previousIndex = -1;

        // Verifica Vitória
        if (_matches == (_gameBoard.length / 2)) {
          Timer(Duration(milliseconds: 500), _showWinDialog);
        }
      } else {
        // ERROU
        _wait = true;
        Timer(Duration(milliseconds: 1000), () {
          setState(() {
            _cardFlips[index] = false;
            _cardFlips[_previousIndex] = false;
            _previousIndex = -1;
            _wait = false;
          });
        });
      }
    }
  }

  void _showWinDialog() {
    // SALVA O RECORDE NO SCORE MANAGER
    ScoreManager.updateScore('memory', _moves);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(Icons.emoji_events, size: 60, color: Colors.amber),
            SizedBox(height: 10),
            Text("Parabéns!", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          "Você completou o modo ${_isHardMode ? 'DIFÍCIL' : 'FÁCIL'} em $_moves tentativas.\nResultado salvo!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewGame();
            },
            child: Text(
              "Jogar Novamente",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
          'Memória Visual',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Botão Switch para trocar dificuldade
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Row(
                children: [
                  Text(
                    "Difícil",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: _isHardMode,
                    activeColor: Colors.amber,
                    onChanged: (value) {
                      setState(() {
                        _isHardMode = value;
                        _startNewGame();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Placar de Tentativas
              Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app, size: 20, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      "Tentativas: $_moves",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // Modo Difícil: 4 colunas (menor). Modo Fácil: 3 colunas (maior)
                    crossAxisCount: _isHardMode ? 4 : 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _gameBoard.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onCardTap(index),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        decoration: BoxDecoration(
                          color: _cardFlips[index]
                              ? Colors.white
                              : Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _cardFlips[index]
                              ? Padding(
                                  padding: EdgeInsets.all(
                                    _isHardMode ? 8.0 : 15.0,
                                  ), // Margem menor no difícil
                                  child: Image.network(
                                    _gameBoard[index],
                                    fit: BoxFit.contain,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        },
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Icons.pets,
                                          color: Colors.grey,
                                        ),
                                  ),
                                )
                              : Icon(
                                  Icons.star_rounded,
                                  color: Colors.white.withOpacity(0.4),
                                  size: _isHardMode
                                      ? 30
                                      : 40, // Ícone menor no difícil
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
