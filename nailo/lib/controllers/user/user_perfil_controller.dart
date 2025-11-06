import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nailo/controllers/auth_controller.dart'; // Importe o AuthController

class PerfilController extends GetxController {

  // Pega o AuthController que já está na memória (injetado no main.dart)
  // O AuthController é a "fonte da verdade" sobre quem está logado
  final AuthController authController = Get.find<AuthController>();

  /// Navega para a tela de edição de perfil
  void onEditPressed() {
    // Vamos supor que você tenha uma rota /perfil_edit
    Get.toNamed('/perfil_edit');
  }

  /// Executa a lógica de logout
  void onLogoutPressed() {
    // Mostra um diálogo de confirmação antes de sair
    Get.defaultDialog(
      title: 'Sair',
      middleText: 'Tem certeza que deseja sair da sua conta?',
      textConfirm: 'Sim',
      textCancel: 'Não',
      confirmTextColor: Colors.white,
      buttonColor: Color(0xFF5DD9C2), // Cor do botão
      onConfirm: () {
        // Chama a função de logout que está no AuthController
        authController.logout();
      },
    );
  }
}