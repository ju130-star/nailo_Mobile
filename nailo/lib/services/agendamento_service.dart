import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nailo/models/agenda_model.dart';


class AgendamentoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _colecao = 'agendamentos';

  Future<void> criarAgendamento(Agendamento agendamento) async {
    await _db.collection(_colecao).add(agendamento.toJson());
  }

  Future<List<Agendamento>> listarAgendamentosPorUsuario(String userId) async {
    final snapshot = await _db
        .collection(_colecao)
        .where('usuarioId', isEqualTo: userId)
        .orderBy('dataHora')
        .get();

    return snapshot.docs
        .map((doc) => Agendamento.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<void> atualizarAgendamento(String id, Map<String, dynamic> dados) async {
    await _db.collection(_colecao).doc(id).update(dados);
  }

  Future<void> deletarAgendamento(String id) async {
    await _db.collection(_colecao).doc(id).delete();
  }
}
