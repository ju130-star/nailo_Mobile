// Este modelo representa um item da sua lista de "Agendamentos"
class AgendamentoModel {
  final String id;
  final String servico;
  final String profissionalNome;
  final DateTime dataHora;
  final String local;

  AgendamentoModel({
    required this.id,
    required this.servico,
    required this.profissionalNome,
    required this.dataHora,
    required this.local,
  });

  // Você também teria aqui métodos fromJson/toJson para a API
  factory AgendamentoModel.fromJson(Map<String, dynamic> json) {
    return AgendamentoModel(
      id: json['id'],
      servico: json['servico'],
      profissionalNome: json['profissionalNome'],
      dataHora: DateTime.parse(json['dataHora']),
      local: json['local'],
    );
  }
}