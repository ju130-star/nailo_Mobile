import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart'; // 1. Importe o GetX
import 'package:nailo/models/agendamento_model.dart'; // Importe seus modelos
import 'package:nailo/models/profissional_model.dart';

// 2. Use 'extends GetxService' para que o Get.put() funcione
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
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Bearer SEU_TOKEN'
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

Future<Map<String, dynamic>> login(Map<String, dynamic> credentials) async {
    try {
      // 1. Chama seu método POST genérico
      final response = await post('auth/login', credentials);
      // Supondo que a API retorna { "token": "...", "user": {...} }
      return response;
    } catch (e) {
      print('Erro na API de Login: $e');
      rethrow; // Relança o erro para ser tratado no Controller
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      // 1. Chama seu método POST genérico
      final response = await post('auth/register', userData);
      // Supondo que a API retorna { "token": "...", "user": {...} }
      return response;
    } catch (e) {
      print('Erro na API de Registro: $e');
      rethrow; // Relança o erro para ser tratado no Controller
    }
  }
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null; // Lida com respostas vazias
      return jsonDecode(response.body);
    } else {
      print('Erro na API: ${response.body}'); // Útil para debug
      throw Exception('Erro na API: ${response.statusCode}');
    }
  }

  // --- 2. MÉTODOS ESPECÍFICOS DO APP (O que seu Controller precisa) ---

  /// Busca na API a lista de agendamentos de um usuário específico.
  Future<List<AgendamentoModel>> getMeusAgendamentos(String userId) async {
    try {
      // 1. Usa seu método 'get' genérico
      final List<dynamic> jsonData = await get('agendamentos/usuario/$userId');

      // 2. Mapeia a lista de JSON para uma lista de Modelos
      List<AgendamentoModel> agendamentos = jsonData
          .map((item) => AgendamentoModel.fromJson(item))
          .toList();

      // 3. Retorna a lista para o Controller
      return agendamentos;

    } catch (e) {
      print('Erro em getMeusAgendamentos: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  /// Busca a lista de profissionais
  Future<List<ProfissionalModel>> getProfissionais() async {
    try {
      // 1. Usa seu método 'get' genérico
      final List<dynamic> jsonData = await get('profissionais');

      // 2. Mapeia para Modelos
      List<ProfissionalModel> profissionais = jsonData
          .map((item) => ProfissionalModel.fromJson(item))
          .toList();

      return profissionais;

    } catch (e) {
      print('Erro em getProfissionais: $e');
      return []; // Retorna lista vazia
    }
  }

  /// Cancela um agendamento
  Future<void> cancelarAgendamento(String agendamentoId) async {
    try {
      // 1. Usa seu método 'delete'
      await delete('agendamentos/$agendamentoId');
      
    } catch (e) {
      print('Erro em cancelarAgendamento: $e');
      throw Exception('Falha ao cancelar agendamento'); // Repassa o erro
    }
    
  }
  
}