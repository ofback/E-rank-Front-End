class RankingDTO {
  final String nickname;
  final int pontuacao;
  final int vitorias;
  final int kills;

  RankingDTO({
    required this.nickname,
    required this.pontuacao,
    required this.vitorias,
    required this.kills,
  });

  factory RankingDTO.fromJson(Map<String, dynamic> json) {
    return RankingDTO(
      nickname: json['nickname'] ?? 'Desconhecido',
      pontuacao: (json['pontuacao'] as num?)?.toInt() ?? 0,
      vitorias: (json['vitorias'] as num?)?.toInt() ?? 0,
      kills: (json['kills'] as num?)?.toInt() ?? 0,
    );
  }
}
