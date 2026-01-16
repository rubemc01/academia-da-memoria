import 'package:flutter/material.dart';
import '../score_manager.dart'; // Importa a lógica dos pontos

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    int brainLevel = ScoreManager.getBrainLevel();

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil Cognitivo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // CARTÃO DE NÍVEL GERAL
            Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.4),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Seu Nível Cerebral",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "$brainLevel XP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _getRankName(brainLevel),
                            style: TextStyle(
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.psychology, size: 80, color: Colors.white24),
                ],
              ),
            ),

            SizedBox(height: 30),

            // GRÁFICO DE HABILIDADES
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Radar de Habilidades",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            SizedBox(height: 20),

            _buildSkillBar(
              "Memória Visual",
              _calcPercent(ScoreManager.highScores['memory'], 20, true),
              Colors.blue,
            ),
            _buildSkillBar(
              "Foco & Sequência",
              _calcPercent(ScoreManager.highScores['sequence'], 15, false),
              Colors.orange,
            ),
            _buildSkillBar(
              "Agilidade Mental",
              _calcPercent(ScoreManager.highScores['math'], 30, false),
              Colors.teal,
            ),
            _buildSkillBar(
              "Controle Inibitório",
              _calcPercent(ScoreManager.highScores['stroop'], 20, false),
              Colors.redAccent,
            ),

            SizedBox(height: 30),

            // GRID DE RECORDES
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Melhores Marcas",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            SizedBox(height: 15),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 2.2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildRecordCard(
                  "Memória",
                  "${ScoreManager.highScores['memory']} mov.",
                  Icons.grid_view,
                  Colors.blue,
                ),
                _buildRecordCard(
                  "Sequência",
                  "Nível ${ScoreManager.highScores['sequence']}",
                  Icons.lightbulb,
                  Colors.orange,
                ),
                _buildRecordCard(
                  "Flash Num.",
                  "${ScoreManager.highScores['numbers']} díg.",
                  Icons.looks_5,
                  Colors.green,
                ),
                _buildRecordCard(
                  "Stroop",
                  "${ScoreManager.highScores['stroop']} pts",
                  Icons.palette,
                  Colors.redAccent,
                ),
                _buildRecordCard(
                  "Palavras",
                  "Nível ${ScoreManager.highScores['words']}",
                  Icons.auto_stories,
                  Colors.deepPurpleAccent,
                ),
                _buildRecordCard(
                  "Matemática",
                  "${ScoreManager.highScores['math']} pts",
                  Icons.calculate,
                  Colors.teal,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Lógica auxiliar para calcular porcentagem da barra (0.0 a 1.0)
  double _calcPercent(int? score, int maxTarget, bool isReverse) {
    if (score == null || score == 0) return 0.05; // Mínimo visual
    if (isReverse) {
      // Para memória: quanto menos movimentos, melhor. Meta é 12 movimentos.
      if (score <= 12) return 1.0;
      double result = 30 / score;
      return result.clamp(0.0, 1.0);
    } else {
      return (score / maxTarget).clamp(0.0, 1.0);
    }
  }

  String _getRankName(int score) {
    if (score == 0) return "Novato";
    if (score < 100) return "Estudante";
    if (score < 300) return "Atleta Mental";
    return "Grão-Mestre";
  }

  Widget _buildSkillBar(String title, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                "${(percent * 100).toInt()}%",
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(
    String title,
    String score,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(fontSize: 11, color: Colors.grey)),
              Text(
                score,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
