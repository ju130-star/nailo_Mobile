// Este modelo representa um item da sua lista de "Profissionais"
class ProfissionalModel {
  final String id;
  final String nome;
  final String? fotoUrl; // URL da imagem (pode ser nula)

  ProfissionalModel({
    required this.id,
    required this.nome,
    this.fotoUrl,
  });

  factory ProfissionalModel.fromJson(Map<String, dynamic> json) {
    return ProfissionalModel(
      id: json['id'],
      nome: json['nome'],
      fotoUrl: json['fotoUrl'],
    );
  }
}