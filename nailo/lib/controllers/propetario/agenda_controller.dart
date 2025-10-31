
import 'package:nailo/models/agenda_model.dart';

import '../../services/agendamento_service.dart';

class AgendaController extends GetxController {
  var agendamentos = <Agendamento>[].obs;

  @override
  void onInit() {
    carregarAgendamentos();
    super.onInit();
  }

  Future<void> carregarAgendamentos() async {
    final lista = await AgendaService.buscarAgendamentos();
    agendamentos.assignAll(lista);
  }

  Future<void> excluirAgendamento(String id) async {
    await AgendaService.excluirAgendamento(id);
    agendamentos.removeWhere((a) => a.id == id);
  }
}
