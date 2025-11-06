import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nailo/models/agendamento_model.dart';

class HistoricoCard extends StatelessWidget {
  final AgendamentoModel agendamento;
  const HistoricoCard({Key? key, required this.agendamento}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lógica de Cores (baseado no status)
    Color corBorda;
    Color corIcone = Colors.white;
    IconData icone;

    switch (agendamento.status) {
      case 'concluido':
        corBorda = Color(0xFF90D08E); // Verde
        icone = Icons.check;
        break;
      case 'cancelado':
        corBorda = Color(0xFFF09D9D); // Vermelho/Rosa
        icone = Icons.close;
        break;
      default: // 'agendado' ou outros
        corBorda = Colors.grey;
        icone = Icons.hourglass_bottom;
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: corBorda, width: 2.0), // Borda colorida
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE dd/MM', 'pt_BR').format(agendamento.dataHora),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '${DateFormat('HH:mm').format(agendamento.dataHora)} - ${agendamento.servico}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  Text(
                    'Com: ${agendamento.profissionalNome}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            // Círculo com o ícone (como na imagem)
            CircleAvatar(
              radius: 16,
              backgroundColor: corBorda,
              child: Icon(icone, size: 18, color: corIcone),
            ),
          ],
        ),
      ),
    );
  }
}