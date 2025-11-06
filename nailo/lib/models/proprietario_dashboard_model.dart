// Este modelo representa os números do dashboard do proprietário
class ProprietarioDashboardModel {
  final double faturamentoHoje;
  final int totalAgendamentosHoje;
  final int novosClientesMes;

  ProprietarioDashboardModel({
    required this.faturamentoHoje,
    required this.totalAgendamentosHoje,
    required this.novosClientesMes,
  });

  // Converte o JSON vindo da API para o modelo
  factory ProprietarioDashboardModel.fromJson(Map<String, dynamic> json) {
    return ProprietarioDashboardModel(
      // usa '?? 0' como valor padrão caso a API retorne nulo
      faturamentoHoje: (json['faturamentoHoje'] as num?)?.toDouble() ?? 0.0,
      totalAgendamentosHoje: json['totalAgendamentosHoje'] as int? ?? 0,
      novosClientesMes: json['novosClientesMes'] as int? ?? 0,
    );
  }
}