import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart'; // Importe o GetX
import 'package:intl/intl.dart';
import 'package:nailo/models/agendamento_model.dart';
import 'package:nailo/models/procedimento_model.dart';
import 'package:nailo/models/profissional_model.dart';
import 'package:nailo/models/proprietario_dashboard_model.dart'; // Importe o novo model

// Use 'extends GetxService' para que o Get.put() funcione
class ApiService extends GetxService {
  final String baseUrl = 'https://api.exemplo.com'; // Sua URL base

  // --- 1. MÉTODOS GENÉRICOS ---

  Future<dynamic> get(String endpoint) async {
    // Você pode adicionar seu token de autenticação aqui
    // final headers = { 'Authorization': 'Bearer SEU_TOKEN' };
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      // headers: headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    // final headers = {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Bearer SEU_TOKEN'
    // };
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  // --- 2. MANIPULADOR DE RESPOSTA (UMA VEZ SÓ) ---

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null; // Lida com respostas vazias
      return jsonDecode(response.body);
    } else {
      print('Erro na API: ${response.body}'); // Útil para debug
      throw Exception('Erro na API: ${response.statusCode}');
    }
  }

  // --- 3. MÉTODOS DE AUTENTICAÇÃO ---

  Future<Map<String, dynamic>> login(Map<String, dynamic> credentials) async {
    try {
      final response = await post('auth/login', credentials);
      return response;
    } catch (e) {
      print('Erro na API de Login: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await post('auth/register', userData);
      return response;
    } catch (e) {
      print('Erro na API de Registro: $e');
      rethrow;
    }
  }

  // --- 4. MÉTODOS ESPECÍFICOS DO APP (O que seus Controllers precisam) ---

  // Para a UserHome
  Future<List<AgendamentoModel>> getMeusAgendamentos(String userId) async {
    try {
      final List<dynamic> jsonData = await get('agendamentos/usuario/$userId');
      List<AgendamentoModel> agendamentos = jsonData
          .map((item) => AgendamentoModel.fromJson(item))
          .toList();
      return agendamentos;
    } catch (e) {
      print('Erro em getMeusAgendamentos: $e');
      return [];
    }
  }

  // Para a UserHome
  Future<List<ProfissionalModel>> getProfissionais() async {
    try {
      final List<dynamic> jsonData = await get('profissionais');
      List<ProfissionalModel> profissionais = jsonData
          .map((item) => ProfissionalModel.fromJson(item))
          .toList();
      return profissionais;
    } catch (e) {
      print('Erro em getProfissionais: $e');
      return [];
    }
  }

  // Para a UserHome (cancelar)
  Future<void> cancelarAgendamento(String agendamentoId) async {
    try {
      await delete('agendamentos/$agendamentoId');
    } catch (e) {
      print('Erro em cancelarAgendamento: $e');
      throw Exception('Falha ao cancelar agendamento');
    }
  }

  // --- 5. NOVOS MÉTODOS (Para UserAgenda e UserHistorico) ---

  /// Busca agendamentos de um usuário por MÊS e ANO
  Future<List<AgendamentoModel>> getMeusAgendamentosPorMes(String userId, int ano, int mes) async {
    try {
      final List<dynamic> jsonData = await get('agendamentos/usuario/$userId?ano=$ano&mes=$mes');
      List<AgendamentoModel> agendamentos = jsonData
          .map((item) => AgendamentoModel.fromJson(item))
          .toList();
      return agendamentos;
    } catch (e) {
      print('Erro em getMeusAgendamentosPorMes: $e');
      return [];
    }
  }

  /// Busca TODO o histórico (passado) de um usuário
  Future<List<AgendamentoModel>> getMeuHistorico(String userId) async {
    try {
      final List<dynamic> jsonData = await get('agendamentos/usuario/$userId/historico');
      List<AgendamentoModel> historico = jsonData
          .map((item) => AgendamentoModel.fromJson(item))
          .toList();
      return historico;
    } catch (e) {
      print('Erro em getMeuHistorico: $e');
      return [];
    }
  }

  // --- 6. NOVOS MÉTODOS (Para ProprietarioHome) ---
  
  /// Busca os números (stats) do dashboard do proprietário
  Future<ProprietarioDashboardModel> getProprietarioStats(String userId) async {
    try {
      // Endpoint exemplo: /dashboard/proprietario/ID_USER
      final Map<String, dynamic> jsonData = await get('dashboard/proprietario/$userId');
      return ProprietarioDashboardModel.fromJson(jsonData);
    } catch (e) {
      print('Erro em getProprietarioStats: $e');
      // Retorna um modelo com zeros em caso de falha
      return ProprietarioDashboardModel(faturamentoHoje: 0, totalAgendamentosHoje: 0, novosClientesMes: 0);
    }
  }
  
  /// Busca apenas os agendamentos de HOJE para o proprietário
  Future<List<AgendamentoModel>> getAgendamentosDoDia(String userId) async {
    try {
      // Endpoint exemplo: /agendamentos/proprietario/ID_USER/hoje
      final List<dynamic> jsonData = await get('agendamentos/proprietario/$userId/hoje');
      List<AgendamentoModel> agendamentos = jsonData
          .map((item) => AgendamentoModel.fromJson(item))
          .toList();
      return agendamentos;
    } catch (e) {
      print('Erro em getAgendamentosDoDia: $e');
      return [];
    }
  }
  /// Busca a lista de procedimentos
  Future<List<ProcedimentoModel>> getProcedimentos() async {
    try {
      final List<dynamic> jsonData = await get('procedimentos');
      return jsonData.map((item) => ProcedimentoModel.fromJson(item)).toList();
    } catch (e) {
      print('Erro em getProcedimentos: $e');
      return [];
    }
  }

  /// Busca horários disponíveis para um profissional em uma data
  Future<List<String>> getAvailableSlots(String profissionalId, DateTime data) async {
    try {
      // Converte a data para formato YYYY-MM-DD
      final String dataString = DateFormat('yyyy-MM-dd').format(data);
      // Endpoint exemplo: /horarios/disponiveis/ID_PROFISSIONAL?data=2025-11-06
      final List<dynamic> jsonData = await get('horarios/disponiveis/$profissionalId?data=$dataString');
      
      // A API retorna uma lista de strings, ex: ["09:00", "09:30", "11:00"]
      return List<String>.from(jsonData);
    } catch (e) {
      print('Erro em getAvailableSlots: $e');
      return [];
    }
  }

  /// Cria um novo agendamento
  Future<void> criarAgendamento(Map<String, dynamic> dadosAgendamento) async {
    try {
      // Usa seu método POST genérico
      await post('agendamentos', dadosAgendamento);
    } catch (e) {
      print('Erro em criarAgendamento: $e');
      rethrow; // Lança o erro para o controller
    }
  }
}