class UserModel {
  final String id;
  final String nome;
  final String email;
  final String tipo; // 'user' ou 'proprietario'

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipo,
  });

  // Converte um JSON (vindo da API) para este modelo
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      tipo: json['tipo'] as String,
    );
  }

  // Converte este modelo para JSON (para enviar para a API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'tipo': tipo,
    };
  }
}