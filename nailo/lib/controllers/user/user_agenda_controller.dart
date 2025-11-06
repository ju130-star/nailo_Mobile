import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:nailo/models/agendamento_model.dart';
import 'package:nailo/services/api_service.dart';
import 'package:nailo/controllers/auth_controller.dart';

class UserAgendaController extends GetxController {
  final ApiService _api = Get.find<ApiService>();
  final AuthController _auth = Get.find<AuthController>();

  var isLoading = false.obs;

  // Estado do Calendário
  var focusedDay = DateTime.now().obs;
  var selectedDay = DateTime.now().obs;
  var calendarFormat = CalendarFormat.month.obs;

  // Lista principal de agendamentos (a chave é o dia)
  var agendamentos = <DateTime, List<AgendamentoModel>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Define o dia selecionado como hoje
    selectedDay.value = DateTime(focusedDay.value.year, focusedDay.value.month, focusedDay.value.day);
    // Busca os agendamentos do mês atual
    fetchAgendamentosDoMes(focusedDay.value);
  }

  /// Busca os agendamentos na API para um mês específico
  Future<void> fetchAgendamentosDoMes(DateTime mes) async {
    isLoading(true);
    try {
      final userId = _auth.userLogado.value?.id;
      if (userId == null) return;

      // Você precisa implementar este método na sua ApiService
      final List<AgendamentoModel> lista = await _api.getMeusAgendamentosPorMes(userId, mes.year, mes.month);

      // Processa a lista para o formato do TableCalendar
      agendamentos.clear();
      for (var ag in lista) {
        final dia = DateTime(ag.dataHora.year, ag.dataHora.month, ag.dataHora.day);
        if (agendamentos[dia] == null) {
          agendamentos[dia] = [];
        }
        agendamentos[dia]!.add(ag);
      }
      agendamentos.refresh(); // Notifica o GetX

    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar a agenda: $e');
    } finally {
      isLoading(false);
    }
  }

  /// Chamado quando o usuário troca o mês no calendário
  void onPageChanged(DateTime newFocusedDay) {
    focusedDay.value = newFocusedDay;
    fetchAgendamentosDoMes(newFocusedDay); // Busca os dados do novo mês
  }

  /// Chamado quando o usuário clica em um dia
  void onDaySelected(DateTime newSelectedDay, DateTime newFocusedDay) {
    selectedDay.value = newSelectedDay;
    focusedDay.value = newFocusedDay;
  }

  /// Retorna a lista de eventos para um dia específico (usado pelo TableCalendar)
  List<AgendamentoModel> getEventosDoDia(DateTime dia) {
    return agendamentos[dia] ?? [];
  }
}