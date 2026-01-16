import 'package:flutter/material.dart';
import 'stats_page.dart'; // <--- Importante

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Academia da Memória'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 4,
          bottom: TabBar(
            indicatorColor: Colors.amber,
            indicatorWeight: 4,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.white70,
            labelColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.fitness_center), text: "BÁSICO"),
              Tab(icon: Icon(Icons.psychology), text: "AVANÇADO"),
            ],
          ),
        ),

        // BOTÃO FLUTUANTE PARA RESULTADOS
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StatsPage()),
            );
          },
          label: Text("Resultados"),
          icon: Icon(Icons.bar_chart),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),

        body: TabBarView(
          children: [
            _buildList(context, [
              _GameData(
                'Jogo da Memória',
                'Retenção Visual',
                Icons.grid_view,
                Colors.blue,
                '/memory',
              ),
              _GameData(
                'Sequência de Cores',
                'Atenção e Foco',
                Icons.lightbulb,
                Colors.orange,
                '/sequence',
              ),
              _GameData(
                'Caça ao Intruso',
                'Observação Rápida',
                Icons.person_search,
                Colors.amber[800]!,
                '/odd_one',
              ),
              _GameData(
                'Flash Numérico',
                'Memória de Curto Prazo',
                Icons.looks_5,
                Colors.green,
                '/numbers',
              ),
            ]),
            _buildList(context, [
              _GameData(
                'Matriz Espacial',
                'Memória Espacial',
                Icons.grid_on,
                Colors.indigo,
                '/spatial',
              ),
              _GameData(
                'Desafio das Cores',
                'Controle Inibitório',
                Icons.palette,
                Colors.redAccent,
                '/stroop',
              ),
              _GameData(
                'Matemática Veloz',
                'Agilidade Mental',
                Icons.calculate,
                Colors.teal,
                '/math',
              ),
              _GameData(
                'Mestre das Palavras',
                'Associação e Criatividade',
                Icons.auto_stories,
                Colors.deepPurpleAccent,
                '/words',
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<_GameData> games) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        child: ListView.separated(
          padding: EdgeInsets.all(20),
          itemCount: games.length,
          separatorBuilder: (ctx, i) => SizedBox(height: 15),
          itemBuilder: (ctx, i) {
            return _buildGameButton(
              context,
              games[i].title,
              games[i].subtitle,
              games[i].icon,
              games[i].color,
              games[i].route,
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String route,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        elevation: 2,
        shadowColor: color.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: color.withOpacity(0.5), width: 1.5),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 35),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[300]),
        ],
      ),
    );
  }
}

class _GameData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;
  _GameData(this.title, this.subtitle, this.icon, this.color, this.route);
}
