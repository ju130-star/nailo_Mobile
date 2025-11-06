import 'package:get/get.dart';
import 'package:flutter/material.dart';

// Modelos
import 'package:nailo/models/agendamento_model.dart';
import 'package:nailo/models/profissional_model.dart';

// Serviços e Controllers
import 'package:nailo/services/api_service.dart';
import 'package:nailo/controllers/auth_controller.dart';

class UserHomeController extends GetxController {
  // --- DEPENDÊNCIAS ---
  final AuthController authController = Get.find<AuthController>();
  final ApiService apiService = Get.find<ApiService>();

  // --- ESTADO OBSERVÁVEL ---
  var isLoading = false.obs;
  var userName = 'Cliente'.obs;
  var agendamentos = <AgendamentoModel>[].obs;
  var profissionaisProximos = <ProfissionalModel>[].obs;

  // --- CICLO DE VIDA ---
  @override
  void onInit() {
    super.onInit();
    fetchInitialData(); // Carrega dados ao iniciar
  }

  // --- MÉTODO PRINCIPAL DE CARGA INICIAL ---
  Future<void> fetchInitialData() async {
    try {
      isLoading(true);

      final user = authController.userLogado.value;
      if (user == null) throw Exception('Usuário não logado');

      userName.value = user.nome;

      // Carrega os dados da API simultaneamente
      final results = await Future.wait([
        apiService.getMeusAgendamentos(user.id),
        apiService.getProfissionais(),
      ]);

      agendamentos.assignAll(results[0] as List<AgendamentoModel>);
      profissionaisProximos.assignAll(results[1] as List<ProfissionalModel>);
    } catch (e) {
      Get.snackbar(
        'Erro ao Carregar',
        'Não foi possível carregar os dados da Home: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // --- AÇÕES DO USUÁRIO ---

  void onAgendamentoTap(AgendamentoModel agendamento) {
    Get.toNamed('/detalhes_agendamento', arguments: agendamento.id);
  }

  void showCancelConfirmationDialog(AgendamentoModel agendamento) {
    Get.dialog(
      AlertDialog(
        title: const Text('Deseja cancelar seu agendamento?'),
        content: Text('${agendamento.servico} com ${agendamento.profissionalNome}'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('NÃO'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _cancelarAgendamento(agendamento.id);
            },
            child: const Text('SIM'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelarAgendamento(String agendamentoId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await apiService.cancelarAgendamento(agendamentoId);
      agendamentos.removeWhere((a) => a.id == agendamentoId);

      Get.back(); // Fecha o loading
      Get.snackbar(
        'Sucesso!',
        'Agendamento cancelado com sucesso.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Erro',
        'Erro ao cancelar agendamento: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onProfissionalTap(ProfissionalModel profissional) {
    Get.toNamed('/detalhes_profissional', arguments: profissional.id);
  }

  void onAddAgendamentoPressed() {
    Get.toNamed('/user_novo_agendamento');
  }
}
