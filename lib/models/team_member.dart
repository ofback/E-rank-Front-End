class TeamMember {
  final int userId;
  final String nickname;
  final String cargo; // "Dono", "ViceLider", "Membro"
  final String dataEntrada;

  TeamMember({
    required this.userId,
    required this.nickname,
    required this.cargo,
    required this.dataEntrada,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      userId: json['userId'] ?? 0,
      nickname: json['nickname'] ?? 'Desconhecido',
      cargo: json['cargo'] ?? 'Membro',
      dataEntrada: json['dataEntrada'] ?? '',
    );
  }

  // Helpers para facilitar a verificação de permissões na tela
  bool get isDono => cargo == 'Dono';
  bool get isVice => cargo == 'ViceLider';
  bool get isMembro => cargo == 'Membro';
}
