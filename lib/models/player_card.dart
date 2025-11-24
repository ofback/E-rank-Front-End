class PlayerCard {
  final String nickname;
  final int overall;
  final String role;
  final int vit;
  final int der;
  final int kill;
  final int ass;
  final int hs;
  final int rck;

  PlayerCard({
    required this.nickname,
    required this.overall,
    required this.role,
    required this.vit,
    required this.der,
    required this.kill,
    required this.ass,
    required this.hs,
    required this.rck,
  });

  factory PlayerCard.fromJson(Map<String, dynamic> json) {
    return PlayerCard(
      nickname: json['nickname'] ?? 'Player',
      overall: json['overallRating'] ?? 50,
      role: json['estiloDeJogo'] ?? 'N/A',
      vit: json['vitorias'] ?? 0,
      der: json['derrotas'] ?? 0,
      kill: json['kills'] ?? 0,
      ass: json['assistencias'] ?? 0,
      hs: json['headshots'] ?? 0,
      rck: json['recordKills'] ?? 0,
    );
  }
}
