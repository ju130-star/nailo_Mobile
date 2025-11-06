class AgendamentoModel {
  final String id;
  final String servico;
  final String profissionalNome;
  final DateTime dataHora;
  final String local;
  final String status; // <-- NOVO CAMPO (ex: 'agendado', 'concluido', 'cancelado')

  AgendamentoModel({
    required this.id,
    required this.servico,
    required this.profissionalNome,
    required this.dataHora,
    required this.local,
    required this.status, // <-- Adicionado
  });

  factory AgendamentoModel.fromJson(Map<String, dynamic> json) {
    return AgendamentoModel(
      id: json['id'] as String,
      servico: json['servico'] as String,
      profissionalNome: json['profissionalNome'] as String,
      dataHora: DateTime.parse(json['dataHora'] as String),
      local: json['local'] as String,
      status: json['status'] as String, // <-- Adicionado
    );
  }
}