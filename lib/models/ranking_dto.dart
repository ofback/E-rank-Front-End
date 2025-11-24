class RankingDTO {
  final int posicao;
  final String nickname;
  final int pontuacao;
  final int vitorias;
  final int kills;

  RankingDTO({
    required this.posicao,
    required this.nickname,
    required this.pontuacao,
    required this.vitorias,
    required this.kills,
  });

  factory RankingDTO.fromJson(Map<String, dynamic> json) {
    return RankingDTO(
      posicao: json['posicao'] ?? 0,
      nickname: json['nickname'] ?? 'Desconhecido',
      pontuacao: json['pontuacao'] ?? 0,
      vitorias: json['vitorias'] ?? 0,
      kills: json['kills'] ?? 0,
    );
  }
}
