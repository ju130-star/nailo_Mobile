class Usuario {
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String tipoUsuario; // "cliente" ou "proprietario"
  final String? fotoPerfil;
  final DateTime? dataCadastro;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.tipoUsuario,
    this.fotoPerfil,
    this.dataCadastro,
  });

  factory Usuario.fromJson(Map<String, dynamic> json, String id) {
    return Usuario(
      id: id,
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'] ?? '',
      tipoUsuario: json['tipoUsuario'] ?? 'cliente',
      fotoPerfil: json['fotoPerfil'],
      dataCadastro: json['dataCadastro'] != null
          ? DateTime.parse(json['dataCadastro'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'tipoUsuario': tipoUsuario,
      'fotoPerfil': fotoPerfil,
      'dataCadastro': dataCadastro?.toIso8601String(),
    };
  }
}
