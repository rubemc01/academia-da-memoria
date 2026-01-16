import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SpatialGridGame extends StatefulWidget {
  @override
  _SpatialGridGameState createState() => _SpatialGridGameState();
}

class _SpatialGridGameState extends State<SpatialGridGame> {
  int _gridSize = 3; // Começa 3x3
  int _itemsToMemorize = 3;
  List<int> _targetIndices = [];
  List<int> _selectedIndices = [];
  bool _isMemorizing = false;
  bool _canPlay = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
  }

  void _startGame() {
    setState(() {
      _gridSize = 3;
      _itemsToMemorize = 3;
      _score = 0;
      _nextRound();
    });
  }

  void _nextRound() {
    setState(() {
      _targetIndices = [];
      _selectedIndices = [];
      _isMemorizing = true;
      _canPlay = false;
    });

    // Gera posições aleatórias únicas
    while (_targetIndices.length < _itemsToMemorize) {
      int r = Random().nextInt(_gridSize * _gridSize);
      if (!_targetIndices.contains(r)) _targetIndices.add(r);
    }

    // Mostra por 1.5 segundos
    Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isMemorizing = false;
          _canPlay = true;
        });
      }
    });
  }

  void _handleTap(int index) {
    if (!_canPlay) return;
    if (_selectedIndices.contains(index)) return; // Já clicou

    setState(() {
      _selectedIndices.add(index);
    });

    if (!_targetIndices.contains(index)) {
      // Clicou errado -> Game Over
      _gameOver();
    } else {
      // Clicou certo -> Verifica se acabou
      if (_selectedIndices.length == _targetIndices.length) {
        // Ganhou a rodada
        _score++;
        if (_score % 2 == 0) _itemsToMemorize++; // Aumenta dificuldade
        if (_itemsToMemorize > (_gridSize * _gridSize) / 2) {
          _gridSize++; // Aumenta o grid se ficar muito cheio
          _itemsToMemorize = _gridSize; // Reseta qtd itens
        }

        Timer(Duration(milliseconds: 500), _nextRound);
      }
    }
  }

  void _gameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Fim de Jogo"),
        content: Text("Você memorizou $_score padrões."),
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
        title: Text('Matriz Espacial'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
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
              if (_targetIndices.isEmpty) ...[
                Icon(Icons.grid_on, size: 80, color: Colors.indigo),
                SizedBox(height: 20),
                Text(
                  "Memorize a posição dos quadrados azuis.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text("COMEÇAR", style: TextStyle(fontSize: 20)),
                ),
              ] else ...[
                Text(
                  "Nível $_score",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                SizedBox(height: 20),
                AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    itemCount: _gridSize * _gridSize,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _gridSize,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      // Cores Lógicas
                      Color color = Colors.grey[300]!; // Padrão

                      if (_isMemorizing && _targetIndices.contains(index)) {
                        color = Colors.indigo; // Mostrando padrão
                      } else if (_canPlay && _selectedIndices.contains(index)) {
                        if (_targetIndices.contains(index)) {
                          color = Colors.green; // Acertou
                        } else {
                          color = Colors.red; // Errou
                        }
                      }

                      return GestureDetector(
                        onTap: () => _handleTap(index),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
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
