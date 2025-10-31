import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/proprietario/agenda_controller.dart';

class AgendaView extends StatelessWidget {
  final controller = Get.put(AgendaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda da Esmalteria')),
      body: Obx(() {
        if (controller.agendamentos.isEmpty) {
          return const Center(child: Text('Nenhum agendamento.'));
        }
        return ListView.builder(
          itemCount: controller.agendamentos.length,
          itemBuilder: (context, index) {
            final ag = controller.agendamentos[index];
            return ListTile(
              title: Text(ag.servico),
              subtitle: Text('${ag.data.day}/${ag.data.month} - R\$${ag.preco}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => controller.excluirAgendamento(ag.id),
              ),
            );
          },
        );
      }),
    );
  }
}
