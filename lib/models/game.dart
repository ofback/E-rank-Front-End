class Game {
  final int id;
  final String nome;
  final String genero;

  Game({required this.id, required this.nome, required this.genero});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? 'Sem Nome',
      genero: json['genero'] ?? '',
    );
  }
}
