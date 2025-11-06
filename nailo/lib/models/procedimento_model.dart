class ProcedimentoModel {
  final String id;
  final String nome;
  final double preco;
  final int duracaoMinutos; // Duração (ex: 60 minutos)

  ProcedimentoModel({
    required this.id,
    required this.nome,
    required this.preco,
    required this.duracaoMinutos,
  });

  factory ProcedimentoModel.fromJson(Map<String, dynamic> json) {
    return ProcedimentoModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      preco: (json['preco'] as num).toDouble(),
      duracaoMinutos: json['duracaoMinutos'] as int,
    );
  }
}