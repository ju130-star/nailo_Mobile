class Registro {
  final String id;
  final String usuarioId;        // ID do cliente ou proprietário
  final String tipo;             // Ex: "agendamento", "cancelamento", "pagamento"
  final String descricao;        // Ex: "Cliente cancelou o agendamento do dia 30/10"
  final DateTime dataHora;       // Quando ocorreu
  final double? valor;           // Usado para controle financeiro (opcional)
  final String? agendamentoId;   // Relaciona ao agendamento, se existir

  Registro({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.descricao,
    required this.dataHora,
    this.valor,
    this.agendamentoId,
  });

  /// Construtor a partir de JSON (Firestore ou API)
  factory Registro.fromJson(Map<String, dynamic> json, String id) {
    return Registro(
      id: id,
      usuarioId: json['usuarioId'] ?? '',
      tipo: json['tipo'] ?? '',
      descricao: json['descricao'] ?? '',
      dataHora: DateTime.parse(json['dataHora']),
      valor: json['valor'] != null ? (json['valor'] as num).toDouble() : null,
      agendamentoId: json['agendamentoId'],
    );
  }

  /// Converte o objeto em JSON para salvar no banco
  Map<String, dynamic> toJson() {
    return {
      'usuarioId': usuarioId,
      'tipo': tipo,
      'descricao': descricao,
      'dataHora': dataHora.toIso8601String(),
      'valor': valor,
      'agendamentoId': agendamentoId,
    };
  }
}
