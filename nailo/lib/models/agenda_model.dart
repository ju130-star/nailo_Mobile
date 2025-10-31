class Agendamento {
  final String id;
  final String clienteId;
  final String proprietarioId;
  final String servicoId;
  final DateTime dataHora;
  final String status; // "pendente", "confirmado", "cancelado", "concluido"

  Agendamento({
    required this.id,
    required this.clienteId,
    required this.proprietarioId,
    required this.servicoId,
    required this.dataHora,
    this.status = 'pendente',
  });

  factory Agendamento.fromJson(Map<String, dynamic> json, String id) {
    return Agendamento(
      id: id,
      clienteId: json['clienteId'] ?? '',
      proprietarioId: json['proprietarioId'] ?? '',
      servicoId: json['servicoId'] ?? '',
      dataHora: DateTime.parse(json['dataHora']),
      status: json['status'] ?? 'pendente',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clienteId': clienteId,
      'proprietarioId': proprietarioId,
      'servicoId': servicoId,
      'dataHora': dataHora.toIso8601String(),
      'status': status,
    };
  }
}
