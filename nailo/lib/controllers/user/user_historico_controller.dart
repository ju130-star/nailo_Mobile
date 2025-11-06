import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nailo/models/agendamento_model.dart';
import 'package:nailo/services/api_service.dart';
import 'package:nailo/controllers/auth_controller.dart';

class UserHistoricoController extends GetxController {
  final ApiService _api = Get.find<ApiService>();
  final AuthController _auth = Get.find<AuthController>();

  var isLoading = false.obs;
  
  // Lista Completa (vinda da API)
  var listaHistoricoCompleto = <AgendamentoModel>[].obs;
  
  // Listas Separadas (para a View)
  var historicoRecente = <AgendamentoModel>[].obs;
  var historicoAntigo = <AgendamentoModel>[].obs;

  // Estado da Busca
  var isSearching = false.obs;
  var listaBusca = <AgendamentoModel>[].obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchHistorico();
  }

  /// Busca o histórico completo na API
  Future<void> fetchHistorico() async {
    isLoading(true);
    try {
      final userId = _auth.userLogado.value?.id;
      if (userId == null) return;

      // Você precisa implementar este método na sua ApiService
      listaHistoricoCompleto.value = await _api.getMeuHistorico(userId);
      
      // Separa as listas
      separarHistorico();
      
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar o histórico: $e');
    } finally {
      isLoading(false);
    }
  }

  /// Separa a lista completa em "Recente" e "Antigo"
  void separarHistorico() {
    historicoRecente.clear();
    historicoAntigo.clear();
    
    final dataLimite = DateTime.now().subtract(Duration(days: 30)); // 30 dias atrás

    for (var ag in listaHistoricoCompleto) {
      if (ag.dataHora.isAfter(dataLimite)) {
        historicoRecente.add(ag);
      } else {
        historicoAntigo.add(ag);
      }
    }
  }

  /// Chamado quando o texto da busca muda
  void onSearchChanged(String query) {
    if (query.isEmpty) {
      isSearching.value = false;
      listaBusca.clear();
      return;
    }

    isSearching.value = true;
    listaBusca.value = listaHistoricoCompleto.where((ag) {
      final queryLower = query.toLowerCase();
      final servico = ag.servico.toLowerCase();
      final profissional = ag.profissionalNome.toLowerCase();
      
      return servico.contains(queryLower) || profissional.contains(queryLower);
    }).toList();
  }

  /// Limpa a busca
  void clearSearch() {
    searchController.clear();
    isSearching.value = false;
    listaBusca.clear();
  }
}