// lib/score_manager.dart

class ScoreManager {
  // Guarda os recordes (0 significa que ainda não jogou)
  static Map<String, int> highScores = {
    'memory': 0, // Menor número de tentativas (Melhor)
    'sequence': 0, // Maior nível
    'numbers': 0, // Maior número de dígitos
    'stroop': 0, // Maior pontuação
    'words': 0, // Maior nível
    'spatial': 0, // Maior nível
    'odd_one': 0, // Maior pontuação
    'math': 0, // Maior pontuação
  };

  // Atualiza o recorde
  static void updateScore(String gameId, int newScore) {
    if (gameId == 'memory') {
      // No jogo da memória, MENOS é melhor.
      // Se for 0 (primeira vez) ou se o novo for menor que o recorde, atualiza.
      int current = highScores[gameId]!;
      if (current == 0 || newScore < current) {
        highScores[gameId] = newScore;
      }
    } else {
      // Nos outros, MAIS é melhor.
      if (newScore > highScores[gameId]!) {
        highScores[gameId] = newScore;
      }
    }
  }

  // Calcula um "Nível Cerebral" fictício para o Dashboard
  static int getBrainLevel() {
    int total = 0;
    total += highScores['sequence']! * 10;
    total += highScores['numbers']! * 10;
    total += highScores['math']!;
    total += highScores['stroop']!;
    total += highScores['words']! * 10;

    // Bônus se completou a memória com poucos movimentos
    if (highScores['memory']! > 0 && highScores['memory']! < 15) total += 100;
    if (highScores['memory']! > 0 && highScores['memory']! < 30) total += 50;

    return total;
  }
}
