class TeamMember {
  final int userId;
  final String nickname;
  final String cargo;
  final String dataEntrada;
  final String status;

  TeamMember({
    required this.userId,
    required this.nickname,
    required this.cargo,
    required this.dataEntrada,
    required this.status,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      userId: json['userId'] ?? 0,
      nickname: json['nickname'] ?? 'Desconhecido',
      cargo: json['cargo'] ?? 'Membro',
      dataEntrada: json['dataEntrada'] ?? '',
      status: json['status'] ?? 'P',
    );
  }

  bool get isDono => cargo == 'Dono';
  bool get isVice => cargo == 'ViceLider';
  bool get isMembro => cargo == 'Membro';
  bool get isPendente => status == 'P';
}
