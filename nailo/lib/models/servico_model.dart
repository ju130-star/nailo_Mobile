class Servico {
  final String id;
  final String nome;
  final String descricao;
  final double preco;
  final Duration duracao; // Duração média do serviço
  final bool ativo;

  Servico({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.duracao,
    this.ativo = true,
  });

  factory Servico.fromJson(Map<String, dynamic> json, String id) {
    return Servico(
      id: id,
      nome: json['nome'] ?? '',
      descricao: json['descricao'] ?? '',
      preco: (json['preco'] ?? 0).toDouble(),
      duracao: Duration(minutes: json['duracao'] ?? 0),
      ativo: json['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'duracao': duracao.inMinutes,
      'ativo': ativo,
    };
  }
}
