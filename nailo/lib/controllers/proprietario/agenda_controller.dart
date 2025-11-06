// Em: features/agenda/controller/agenda_controller.dart

import 'package:get/get.dart';
// Importe seu AuthController e seus models
import 'package:nailo_Mobile/core/controllers/auth_controller.dart'; 
import 'package:nailo_Mobile/core/models/agendamento_model.dart';
import 'package:nailo_Mobile/core/services/api_service.dart';

class AgendaController extends GetxController {
  // 1. Injetar ou encontrar o AuthController para saber quem está logado
  final AuthController authController = Get.find();
  
  // 2. Uma lista observável para os agendamentos
  var listaAgendamentos = <AgendamentoModel>[].obs;
  var isLoading = false.obs;
  
  // 3. O 'ApiService' (serviço que fala com a API)
  final ApiService _api = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchAgendamentos(); // Busca os agendamentos assim que o controller é iniciado
  }

  // 4. A MÁGICA ESTÁ AQUI
  void fetchAgendamentos() async {
    try {
      isLoading(true);

      List<AgendamentoModel> agendamentosDaApi;

      // **Lógica condicional baseada no tipo de usuário**
      if (authController.userType == 'proprietario') {
        // Se for proprietário, ele busca TODOS os agendamentos do negócio
        agendamentosDaApi = await _api.getAgendamentosProprietario();
      } else {
        // Se for usuário, ele busca APENAS os agendamentos daquele usuário
        agendamentosDaApi = await _api.getMeusAgendamentos(authController.userId);
      }

      // Atualiza a lista
      listaAgendamentos.value = agendamentosDaApi;
      
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível buscar agendamentos: $e');
    } finally {
      isLoading(false);
    }
  }
  
  
}