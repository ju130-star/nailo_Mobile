import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:nailo/controllers/user/user_agenda_controller.dart';
import 'package:nailo/models/agendamento_model.dart';

class UserAgendaView extends StatelessWidget {
  const UserAgendaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserAgendaController controller = Get.put(UserAgendaController());
    const Color corPrincipal = Color(0xFF5DD9C2);
    const Color corFundo = Color(0xFFC5F3F4);

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corPrincipal,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.style, color: Colors.black), // Logo
            SizedBox(width: 8),
            Text('Nailo', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Column(
        children: [
          // O Widget do Calendário
          Obx(() => TableCalendar<AgendamentoModel>(
                locale: 'pt_BR', // (Lembre-se de inicializar o intl no main.dart)
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: controller.focusedDay.value,
                selectedDayPredicate: (day) => isSameDay(controller.selectedDay.value, day),
                calendarFormat: controller.calendarFormat.value,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                
                // Carrega os eventos (bolinhas)
                eventLoader: controller.getEventosDoDia, 
                
                // Ações do usuário
                onDaySelected: controller.onDaySelected,
                onPageChanged: controller.onPageChanged,
                onFormatChanged: (format) {
                  controller.calendarFormat.value = format;
                },

                // Estilização para combinar com seu design
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: Colors.black),
                  weekendTextStyle: TextStyle(color: Colors.black54),
                  selectedDecoration: BoxDecoration(
                    color: corPrincipal,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.pink.shade100,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration( // Bolinha do evento
                    color: Colors.pink.shade700,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(fontSize: 18, color: Colors.black),
                  leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                  rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.black54),
                  weekendStyle: TextStyle(color: Colors.pink.shade700), // S e D
                ),
              )),
          
          // Divisor
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Divider(color: corPrincipal, thickness: 1),
          ),

          // Lista de Agendamentos do Dia Selecionado
          Expanded(
            child: Obx(() {
              final eventosDoDia = controller.getEventosDoDia(controller.selectedDay.value);
              if (eventosDoDia.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhum agendamento para este dia.',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                );
              }
              // Mostra a lista (o card da sua imagem)
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: eventosDoDia.length,
                itemBuilder: (context, index) {
                  final agendamento = eventosDoDia[index];
                  // Card simples (substitua pelo seu AgendamentoCard se tiver)
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(
                        '${agendamento.servico} - ${agendamento.profissionalNome}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${DateFormat('HH:mm').format(agendamento.dataHora)} - ${agendamento.local}'
                      ),
                      onTap: () { /* Get.toNamed(...) */ },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: corPrincipal,
        selectedItemColor: Colors.pink.shade700,
        unselectedItemColor: Colors.black.withOpacity(0.6),
        currentIndex: 1, // 1 é o índice da "Agenda"
        onTap: (index) {
          if (index == 0) Get.offNamed('/user_home');
          if (index == 2) Get.toNamed('/user_historico');
          if (index == 3) Get.toNamed('/perfil');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'), // Ícone atualizado
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}