class Challenge {
  final int id;
  final String desafianteNome;
  final String status;
  final String dataHora;

  Challenge({
    required this.id,
    required this.desafianteNome,
    required this.status,
    required this.dataHora,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] ?? 0,
      desafianteNome: json['desafianteNome'] ?? 'Desconhecido',
      status: json['status'] ?? 'P',
      dataHora: json['dataHora'] ?? '',
    );
  }
}
