import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // <-- ADICIONE ESTA LINHA

// Importe o Controller e os NOVOS WIDGETS
import 'package:nailo/controllers/user/user_home_controller.dart';
import 'package:nailo/widgets/agendamento_card.dart';
import 'package:nailo/widgets/profissional_avatar.dart';

class UserHomeView extends StatelessWidget {
  const UserHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Instancia o Controller
    final UserHomeController controller = Get.put(UserHomeController());

    // 🔹 Inicializa o locale de datas antes de formatar
    initializeDateFormatting('pt_BR', null);

    // 🔹 Define o idioma padrão das datas
    Intl.defaultLocale = 'pt_BR';

    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade100,
        elevation: 0,
        title: Obx(() => Text(
              'Olá, ${controller.userName.value}',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.pink.shade700),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: Colors.pink.shade700),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchHomeData,
          color: Colors.pink.shade700,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Agora o formato de data vai funcionar sem erro
                Text(
                  DateFormat.yMMMMd('pt_BR').format(DateTime.now()),
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                ),
                SizedBox(height: 20),

                Text(
                  'Agendamentos',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(height: 10),

                Obx(() => controller.agendamentos.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhum agendamento futuro.',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.agendamentos.length,
                        itemBuilder: (context, index) {
                          final agendamento = controller.agendamentos[index];
                          return AgendamentoCard(
                            agendamento: agendamento,
                            onTap: () =>
                                controller.onAgendamentoTap(agendamento),
                            onLongPress: () => controller
                                .showCancelConfirmationDialog(agendamento),
                          );
                        },
                      )),
                SizedBox(height: 30),

                Text(
                  'Profissionais',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(height: 10),

                SizedBox(
                  height: 100,
                  child: Obx(() => controller.profissionais.isEmpty
                      ? Center(
                          child: Text(
                            'Nenhum profissional encontrado.',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.profissionais.length,
                          itemBuilder: (context, index) {
                            final profissional =
                                controller.profissionais[index];
                            return ProfissionalAvatar(
                              profissional: profissional,
                              onTap: () =>
                                  controller.onProfissionalTap(profissional),
                            );
                          },
                        )),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onAddAgendamentoPressed,
        backgroundColor: Colors.pink.shade700,
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.cyan.shade100,
        selectedItemColor: Colors.pink.shade700,
        unselectedItemColor: Colors.grey.shade600,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) Get.toNamed('/user_agenda');
          if (index == 2) Get.toNamed('/user_historico');
          if (index == 3) Get.toNamed('/perfil');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Agenda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Histórico'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
