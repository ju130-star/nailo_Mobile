class Notificacao {
  final String id;
  final String usuarioId;
  final String titulo;
  final String mensagem;
  final DateTime dataEnvio;
  final bool lida;

  Notificacao({
    required this.id,
    required this.usuarioId,
    required this.titulo,
    required this.mensagem,
    required this.dataEnvio,
    this.lida = false,
  });

  factory Notificacao.fromJson(Map<String, dynamic> json, String id) {
    return Notificacao(
      id: id,
      usuarioId: json['usuarioId'] ?? '',
      titulo: json['titulo'] ?? '',
      mensagem: json['mensagem'] ?? '',
      dataEnvio: DateTime.parse(json['dataEnvio']),
      lida: json['lida'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuarioId': usuarioId,
      'titulo': titulo,
      'mensagem': mensagem,
      'dataEnvio': dataEnvio.toIso8601String(),
      'lida': lida,
    };
  }
}
