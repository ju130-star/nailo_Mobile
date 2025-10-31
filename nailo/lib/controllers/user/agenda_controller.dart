import 'package:get/get.dart';
import '../../models/agendamento_model.dart';
import '../../services/agendamento_service.dart';

class AgendaController extends GetxController {
  var agendamentos = <Agendamento>[].obs;

  @override
  void onInit() {
    carregarAgendamentos();
    super.onInit();
  }

  Future<void> carregarAgendamentos() async {
    final lista = await AgendamentoService.buscarAgendamentos();
    agendamentos.assignAll(lista);
  }

  Future<void> excluirAgendamento(String id) async {
    await AgendamentoService.excluirAgendamento(id);
    agendamentos.removeWhere((a) => a.id == id);
  }
}
