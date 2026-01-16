import 'package:flutter/material.dart';

// Importando TODOS os 8 jogos
import 'screens/home_page.dart';
import 'screens/memory_game.dart';
import 'screens/sequence_game.dart';
import 'screens/numbers_game.dart';
import 'screens/stroop_game.dart';
import 'screens/word_memory_game.dart';
import 'screens/spatial_grid_game.dart'; // Novo
import 'screens/odd_one_out_game.dart'; // Novo
import 'screens/math_game.dart'; // Novo

void main() {
  runApp(MeuAppMemoria());
}

class MeuAppMemoria extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academia da Memória',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: HomePage(),

      // 8 Rotas registradas
      routes: {
        '/memory': (context) => MemoryGame(),
        '/sequence': (context) => SequenceGame(),
        '/numbers': (context) => NumbersGame(),
        '/stroop': (context) => StroopGame(),
        '/words': (context) => WordMemoryGame(),
        '/spatial': (context) => SpatialGridGame(), // Rota nova
        '/odd_one': (context) => OddOneOutGame(), // Rota nova
        '/math': (context) => MathGame(), // Rota nova
      },
    );
  }
}
