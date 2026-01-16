import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class WordMemoryGame extends StatefulWidget {
  @override
  _WordMemoryGameState createState() => _WordMemoryGameState();
}

class _WordMemoryGameState extends State<WordMemoryGame> {
  // Banco de palavras simples para criar histórias
  final List<String> _allWords = [
    'GATO',
    'SOL',
    'MESA',
    'CARRO',
    'ÁRVORE',
    'LIVRO',
    'CHAVE',
    'LUZ',
    'SAPATO',
    'BOLA',
    'CASA',
    'PEIXE',
    'DENTE',
    'ANEL',
    'LUA',
    'PÃO',
    'TREM',
    'FLOR',
    'REI',
    'OVO',
    'VELA',
    'LOBO',
    'GELO',
    'FOGO',
    'NAVIO',
    'MALA',
    'RATO',
    'UVA',
    'COPO',
    'FACA',
    'DADO',
    'LEÃO',
  ];

  List<String> _roundWords = []; // As palavras da rodada atual
  List<String> _shuffledOptions =
      []; // As mesmas palavras, mas embaralhadas para o clique

  int _level = 3; // Começa com 3 palavras
  int _currentWordIndex = 0; // Qual palavra está sendo mostrada agora
  bool _isMemorizing = false; // Fase de ver as palavras
  bool _isTesting = false; // Fase de clicar

  // Controle de acertos na fase de teste
  int _clickIndex = 0;

  void _startGame() {
    setState(() {
      _level = 3;
      _startRound();
    });
  }

  void _startRound() {
    // 1. Seleciona palavras aleatórias
    var rng = Random();
    List<String> pool = List.from(_allWords)..shuffle();
    _roundWords = pool.take(_level).toList();

    // 2. Prepara para mostrar
    _shuffledOptions = [];
    _currentWordIndex = 0;
    _isMemorizing = true;
    _isTesting = false;
    _clickIndex = 0;

    setState(() {});

    // 3. Loop para mostrar uma palavra por vez
    _showNextWord();
  }

  void _showNextWord() {
    if (_currentWordIndex < _roundWords.length) {
      // Mostra a palavra por 2 segundos
      Timer(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _currentWordIndex++;
          });
          // Pequena pausa em branco entre palavras (0.5s)
          Timer(Duration(milliseconds: 500), _showNextWord);
        }
      });
    } else {
      // Acabaram as palavras, hora do teste!
      setState(() {
        _isMemorizing = false;
        _isTesting = true;
        // Cria as opções embaralhadas
        _shuffledOptions = List.from(_roundWords)..shuffle();
      });
    }
  }

  void _handleWordTap(String selectedWord) {
    // Verifica se a palavra clicada é a correta na sequência original
    String correctWord = _roundWords[_clickIndex];

    if (selectedWord == correctWord) {
      // Acertou!
      setState(() {
        _clickIndex++; // Avança para esperar a próxima palavra correta
        // Remove a palavra da tela para limpar visualmente (opcional, mas fica legal)
        _shuffledOptions.remove(selectedWord);
      });

      // Se acabou a lista, ganhou a rodada
      if (_shuffledOptions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Perfeito! Aumentando dificuldade..."),
            backgroundColor: Colors.deepPurple,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _level++; // Aumenta o nível
        });
        Timer(Duration(seconds: 1), _startRound);
      }
    } else {
      // Errou!
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Memória Falhou!"),
        content: Text(
          "Você esqueceu a ordem.\nChegou ao nível $_level (palavras).",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame(); // Reinicia do nível 3
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
          'Mestre das Palavras',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
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
              // --- TELA INICIAL ---
              if (!_isMemorizing && !_isTesting) ...[
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_stories,
                    size: 80,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Técnica Profissional:",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Crie uma história visual conectando as palavras.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Text(
                  "Ex: GATO + SOL -> Um gato voando até o sol.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                    backgroundColor: Colors.deepPurpleAccent,
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

                // --- FASE 1: MEMORIZAÇÃO (MOSTRANDO PALAVRAS) ---
              ] else if (_isMemorizing) ...[
                Text(
                  "Memorize a sequência...",
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                if (_currentWordIndex < _roundWords.length)
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Text(
                      _roundWords[_currentWordIndex],
                      key: ValueKey(_roundWords[_currentWordIndex]),
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        letterSpacing: 2,
                      ),
                    ),
                  )
                else
                  CircularProgressIndicator(), // Pequeno loading antes de mudar de tela
                Spacer(),
                LinearProgressIndicator(
                  value: (_currentWordIndex) / _roundWords.length,
                  backgroundColor: Colors.grey[200],
                  color: Colors.deepPurpleAccent,
                ),
                SizedBox(height: 20),
                Text("Palavra ${_currentWordIndex + 1} de $_level"),

                // --- FASE 2: TESTE (SELECIONAR ORDEM) ---
              ] else if (_isTesting) ...[
                Text(
                  "Toque na ordem correta!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[800],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Qual a próxima palavra?",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Center(
                    child: Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      alignment: WrapAlignment.center,
                      children: _shuffledOptions.map((word) {
                        return ElevatedButton(
                          onPressed: () => _handleWordTap(word),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurpleAccent,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                color: Colors.deepPurpleAccent.withOpacity(0.5),
                              ),
                            ),
                            elevation: 3,
                          ),
                          child: Text(
                            word,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
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
