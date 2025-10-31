class Preco {
  final String id;
  final String servicoId;
  final double valor;
  final DateTime dataAtualizacao;

  Preco({
    required this.id,
    required this.servicoId,
    required this.valor,
    required this.dataAtualizacao,
  });

  factory Preco.fromJson(Map<String, dynamic> json, String id) {
    return Preco(
      id: id,
      servicoId: json['servicoId'] ?? '',
      valor: (json['valor'] ?? 0).toDouble(),
      dataAtualizacao: DateTime.parse(json['dataAtualizacao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'servicoId': servicoId,
      'valor': valor,
      'dataAtualizacao': dataAtualizacao.toIso8601String(),
    };
  }
}
