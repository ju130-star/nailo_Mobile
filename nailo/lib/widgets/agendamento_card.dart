import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nailo/models/agendamento_model.dart'; // Para formatar datas
 // Importe seu modelo

class AgendamentoCard extends StatelessWidget {
  final AgendamentoModel agendamento;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress; // Para cancelar

  const AgendamentoCard({
    Key? key,
    required this.agendamento,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.pink.shade50, // Cor do card como na imagem
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress, // Ação de segurar para cancelar
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Coluna para as informações de texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // Formata a data. Ex: "Segunda 06/11"
                      DateFormat('EEEE dd/MM', 'pt_BR').format(agendamento.dataHora),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.pink.shade800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${agendamento.servico} - ${agendamento.profissionalNome}',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      // Formata a hora e local. Ex: "09:30 - Rua X, 123"
                      '${DateFormat('HH:mm').format(agendamento.dataHora)} - ${agendamento.local}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Ícone lateral
              Icon(Icons.person, color: Colors.pink.shade700, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}