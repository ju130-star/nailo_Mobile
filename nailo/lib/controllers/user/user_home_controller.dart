import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Necessário para o AlertDialog

// Importe seus modelos e serviços
import 'package:nailo/models/agendamento_model.dart';
import 'package:nailo/models/profissional_model.dart';
import 'package:nailo/services/api_service.dart';// Seu serviço de API
import 'package:nailo/controllers/auth_controller.dart';// Para pegar o usuário logado

class UserHomeController extends GetxController {
  
  // --- 1. DEPENDÊNCIAS E VARIÁVEIS (NO TOPO DA CLASSE) ---
  
  // Dependências (supondo que já foram injetadas no Get)
  final ApiService _api = Get.find<ApiService>();
  final AuthController _auth = Get.find<AuthController>();

  // --- ESTADO OBSERVÁVEL (Dados que a View vai "ouvir") ---
  var isLoading = false.obs;
  var userName = 'Cliente'.obs;
  var agendamentos = <AgendamentoModel>[].obs; // Lista reativa de agendamentos
  var profissionais = <ProfissionalModel>[].obs; // Lista reativa de profissionais

  // --- 2. CICLO DE VIDA (MÉTODO) ---
  @override
  void onInit() {
    super.onInit();
    fetchHomeData(); // Busca os dados assim que o controller é criado
  }

  // --- 3. LÓGICA / AÇÕES (TODOS OS MÉTODOS AQUI) ---

  // 1. Busca todos os dados da tela
  Future<void> fetchHomeData() async {
    try {
      isLoading(true);
      // Pega o nome do usuário logado
      // (Certifique-se que seu AuthController tem uma variável 'user' ou 'userLogado')
      userName.value = _auth.userLogado.value?.nome ?? 'Cliente'; 

      // Busca os dados da API em paralelo
      final [agendamentosDaApi, profissionaisDaApi] = await Future.wait([
        _api.getMeusAgendamentos(_auth.userLogado.value!.id), // Use o ID do usuário logado
        _api.getProfissionais(),
      ]);

      // Atualiza as listas reativas
      agendamentos.assignAll(agendamentosDaApi as Iterable<AgendamentoModel>);
      profissionais.assignAll(profissionaisDaApi as Iterable<ProfissionalModel>);

    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar os dados: $e');
    } finally {
      isLoading(false);
    }
  }

  // 2. Ação para o botão "+"
  void onAddAgendamentoPressed() {
    Get.toNamed('/user_novo_agendamento'); // Navega para a tela de criar agendamento
  }
  
  // 3. Ação para clicar em um profissional
  void onProfissionalTap(ProfissionalModel profissional) {
    Get.toNamed('/detalhes_profissional', arguments: profissional.id);
  }

  // 4. Ação para mostrar o dialog de cancelamento (LÓGICA DE UI)
  void showCancelConfirmationDialog(AgendamentoModel agendamento) {
    Get.dialog(
      AlertDialog(
        title: Text('Deseja cancelar seu agendamento?'),
        content: Text('${agendamento.servico} com ${agendamento.profissionalNome}'),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Fecha o dialog
            child: Text('NÃO'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Fecha o dialog
              _cancelarAgendamento(agendamento.id); // Chama a lógica interna
            },
            child: Text('SIM'),
          ),
        ],
      ),
    );
  }

  // 5. Lógica interna de cancelamento (LÓGICA DE DADOS)
  Future<void> _cancelarAgendamento(String agendamentoId) async {
    try {
      Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      // Chama a API para cancelar
      await _api.cancelarAgendamento(agendamentoId);
      
      // Remove o item da lista reativa (a UI vai atualizar sozinha)
      agendamentos.removeWhere((ag) => ag.id == agendamentoId);

      Get.back(); // Fecha o loading
      Get.snackbar('Sucesso', 'Agendamento cancelado.');
      
    } catch (e) {
      Get.back(); // Fecha o loading
      Get.snackbar('Erro', 'Não foi possível cancelar o agendamento: $e');
    }
  }

  // 6. MÉTODO DE CLIQUE DO AGENDAMENTO (NO LOCAL CORRETO)
  void onAgendamentoTap(AgendamentoModel agendamento) {
    print('Usuário clicou no agendamento ID: ${agendamento.id}');
    
    // Ação: Navegar para a tela de detalhes
    Get.toNamed(
      '/detalhes_agendamento', 
      arguments: agendamento.id // Envia o ID do agendamento para a próxima tela
    );
  }
}