import 'package:flutter/material.dart';
import 'package:nailo/controllers/user/user_agenda_controller.dart';
import 'package:nailo/controllers/user/user_home_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nailo/models/procedimento_model.dart';
import 'package:nailo/models/profissional_model.dart';
import 'package:nailo/services/api_service.dart';
import 'package:nailo/controllers/auth_controller.dart';

class UserNovoAgendamentoController extends GetxController {
  // --- DEPENDÊNCIAS ---
  final ApiService _api = Get.find<ApiService>();
  final AuthController _auth = Get.find<AuthController>();

  // --- CONTROLADORES DE FORMULÁRIO ---
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController alergiaController = TextEditingController();

  // --- ESTADO DA PÁGINA ---
  var isLoading = false.obs; // Para carregar dados iniciais (listas)
  var isAgendando = false.obs; // Para o botão "AGENDAR"
  var isLoadingSlots = false.obs; // Para carregar horários

  // --- DADOS DO FORMULÁRIO (DROPDOWNS E LISTAS) ---
  var procedimentosList = <ProcedimentoModel>[].obs;
  var profissionaisList = <ProfissionalModel>[].obs;
  var availableTimeSlots = <String>[].obs; // Ex: ["09:00", "10:30"]

  // --- ESTADO DE SELEÇÃO ---
  var selectedProcedimentoId = Rxn<String>();
  var selectedProfissionalId = Rxn<String>();
  var selectedDate = Rxn<DateTime>();
  var selectedTimeSlot = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _preencherDadosDoUsuario();
    _fetchFormularioData();
  }

  /// Pré-preenche Nome e Telefone do usuário logado
  void _preencherDadosDoUsuario() {
    final user = _auth.userLogado.value;
    if (user != null) {
      nomeController.text = user.nome;
      telefoneController.text = user.telefone ?? '';
    }
  }

  /// Busca as listas de profissionais e procedimentos na API
  Future<void> _fetchFormularioData() async {
    isLoading(true);
    try {
      final [procs, profs] = await Future.wait([
        _api.getProcedimentos(), // Você precisa criar este método na ApiService
        _api.getProfissionais(),   // Já criamos este
      ]);
      procedimentosList.assignAll(procs);
      profissionaisList.assignAll(profs);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar os dados do formulário.');
    } finally {
      isLoading(false);
    }
  }

  /// Chamado quando o usuário muda o Profissional ou a Data
  Future<void> fetchAvailableTimeSlots() async {
    if (selectedProfissionalId.value == null || selectedDate.value == null) {
      availableTimeSlots.clear();
      return; // Precisa de profissional E data
    }

    isLoadingSlots(true);
    availableTimeSlots.clear();
    selectedTimeSlot.value = null; // Reseta a hora selecionada

    try {
      // Você precisa criar este método na ApiService
      final slots = await _api.getAvailableSlots(
        selectedProfissionalId.value!,
        selectedDate.value!,
      );
      availableTimeSlots.assignAll(slots);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível buscar horários.');
    } finally {
      isLoadingSlots(false);
    }
  }

  // --- AÇÕES DA VIEW ---

  void onProcedimentoChanged(String? newValue) {
    selectedProcedimentoId.value = newValue;
  }

  void onProfissionalChanged(String? newValue) {
    selectedProfissionalId.value = newValue;
    fetchAvailableTimeSlots(); // Busca horários ao trocar de profissional
  }

  void onDateSelected(DateTime newDate) {
    selectedDate.value = newDate;
    fetchAvailableTimeSlots(); // Busca horários ao trocar de data
  }

  void onTimeSlotSelected(String newSlot) {
    selectedTimeSlot.value = newSlot;
  }

  /// Ação final: Tentar criar o agendamento
  Future<void> criarAgendamento() async {
    // 1. Validação
    if (selectedProcedimentoId.value == null ||
        selectedProfissionalId.value == null ||
        selectedDate.value == null ||
        selectedTimeSlot.value == null ||
        idadeController.text.isEmpty) {
      Get.snackbar('Campos incompletos', 'Por favor, preencha todos os campos e selecione um horário.');
      return;
    }

    isAgendando(true);
    try {
      // Combina a data (Dia/Mes/Ano) com o horário (Hora:Minuto)
      final String horaMinuto = selectedTimeSlot.value!; // "09:30"
      final int hora = int.parse(horaMinuto.split(':')[0]);
      final int minuto = int.parse(horaMinuto.split(':')[1]);
      final DateTime dataHoraFinal = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
        hora,
        minuto,
      );

      // 2. Monta o payload
      final dadosAgendamento = {
        'userId': _auth.userLogado.value!.id,
        'procedimentoId': selectedProcedimentoId.value,
        'profissionalId': selectedProfissionalId.value,
        'dataHora': dataHoraFinal.toIso8601String(), // Formato padrão de API
        'idadeCliente': idadeController.text,
        'alergia': alergiaController.text.isEmpty ? null : alergiaController.text,
      };

      // 3. Envia para a API (Você precisa criar este método)
      await _api.criarAgendamento(dadosAgendamento);

      Get.back(); // Volta para a tela anterior
      Get.snackbar('Sucesso!', 'Seu agendamento foi confirmado.');
      
      // Atualiza a agenda e a home (se elas já estiverem na memória)
      if (Get.isRegistered<UserHomeController>()) {
        Get.find<UserHomeController>().fetchInitialData();
      }
      if (Get.isRegistered<UserAgendaController>()) {
        Get.find<UserAgendaController>().fetchAgendamentosDoMes(DateTime.now());
      }

    } catch (e) {
      Get.snackbar('Erro ao Agendar', 'Não foi possível criar seu agendamento.');
    } finally {
      isAgendando(false);
    }
  }

  @override
  void onClose() {
    // Limpa os controllers de texto
    nomeController.dispose();
    telefoneController.dispose();
    idadeController.dispose();
    alergiaController.dispose();
    super.onClose();
  }
}