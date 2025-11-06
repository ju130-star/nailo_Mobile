import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nailo/controllers/user/user_novo_agendamento_controller.dart';

class UserNovoAgendamentoView extends StatelessWidget {
  const UserNovoAgendamentoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserNovoAgendamentoController controller = Get.put(UserNovoAgendamentoController());
    const Color corPrincipal = Color(0xFF5DD9C2);
    const Color corFundo = Color(0xFFC5F3F4);
    const Color corCard = Colors.white;

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corPrincipal,
        elevation: 0,
        title: Text('Novo Agendamento', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: corPrincipal));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: corCard,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Formulário',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: corPrincipal),
                ),
                SizedBox(height: 24),
                
                // --- Campos de Texto ---
                TextField(
                  controller: controller.nomeController,
                  decoration: InputDecoration(labelText: 'Nome'),
                  enabled: false, // Não deixa editar o nome
                ),
                SizedBox(height: 16),
                TextField(
                  controller: controller.telefoneController,
                  decoration: InputDecoration(labelText: 'Telefone'),
                  enabled: false, // Não deixa editar o telefone
                ),
                SizedBox(height: 16),
                TextField(
                  controller: controller.idadeController,
                  decoration: InputDecoration(labelText: 'Idade'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // --- Dropdown Procedimento ---
                Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedProcedimentoId.value,
                      hint: Text('Procedimento'),
                      isExpanded: true,
                      items: controller.procedimentosList.map((proc) {
                        return DropdownMenuItem(
                          value: proc.id,
                          child: Text(proc.nome),
                        );
                      }).toList(),
                      onChanged: controller.onProcedimentoChanged,
                      decoration: InputDecoration(border: UnderlineInputBorder()),
                    )),
                SizedBox(height: 16),

                // --- Dropdown Profissional ---
                Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedProfissionalId.value,
                      hint: Text('Profissional'),
                      isExpanded: true,
                      items: controller.profissionaisList.map((prof) {
                        return DropdownMenuItem(
                          value: prof.id,
                          child: Text(prof.nome),
                        );
                      }).toList(),
                      onChanged: controller.onProfissionalChanged,
                      decoration: InputDecoration(border: UnderlineInputBorder()),
                    )),
                SizedBox(height: 16),

                TextField(
                  controller: controller.alergiaController,
                  decoration: InputDecoration(labelText: 'Possui alguma alergia? (Opcional)'),
                ),
                SizedBox(height: 24),

                // --- ADIÇÃO: Seletor de Data ---
                Obx(() => TextButton.icon(
                      icon: Icon(Icons.calendar_today, color: corPrincipal),
                      label: Text(
                        controller.selectedDate.value == null
                            ? 'Clique para selecionar uma data'
                            : 'Data: ${DateFormat('dd/MM/yyyy').format(controller.selectedDate.value!)}',
                        style: TextStyle(color: Colors.black87),
                      ),
                      onPressed: () async {
                        final DateTime? data = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate.value ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 90)),
                        );
                        if (data != null) {
                          controller.onDateSelected(data);
                        }
                      },
                    )),
                SizedBox(height: 16),

                // --- Seção de Horários Disponíveis ---
                Text('Horários Disponíveis:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Obx(() {
                  if (controller.isLoadingSlots.value) {
                    return Center(child: CircularProgressIndicator(color: corPrincipal));
                  }
                  if (controller.availableTimeSlots.isEmpty) {
                    return Text(
                      'Selecione um profissional e uma data para ver os horários.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    );
                  }
                  // Grade de horários
                  return Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: controller.availableTimeSlots.map((time) {
                      return Obx(() {
                        final isSelected = controller.selectedTimeSlot.value == time;
                        return ChoiceChip(
                          label: Text(time),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              controller.onTimeSlotSelected(time);
                            }
                          },
                          backgroundColor: Colors.grey.shade200,
                          selectedColor: corPrincipal,
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                        );
                      });
                    }).toList(),
                  );
                }),

                SizedBox(height: 32),
                
                // --- Botão Agendar ---
                Obx(() => ElevatedButton(
                      onPressed: controller.isAgendando.value ? null : controller.criarAgendamento,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corPrincipal,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: controller.isAgendando.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('AGENDAR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    )),
              ],
            ),
          ),
        );
      }),
    );
  }
}