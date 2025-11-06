import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nailo/controllers/auth_controller.dart'; // Seu AuthController
import 'package:nailo/views/widgets/auth_background.dart';
import 'package:nailo/widgets/auth_background.dart'; // O widget de background

class RegistroView extends StatelessWidget {
  const RegistroView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pegar a instância do AuthController que já foi injetada no main.dart
    final AuthController authController = Get.find<AuthController>();

    return AuthBackground(
      title: 'Cadastro', // Título para o card
      child: Column(
        children: [
          TextField(
            controller: authController.emailController, // Reutiliza o controller de email
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 15),
          TextField(
            controller: authController.phoneController, // NOVO: Controller para Telefone
            decoration: InputDecoration(
              labelText: 'Telefone',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 15),
          TextField(
            controller: authController.passwordController, // Reutiliza o controller de senha
            decoration: InputDecoration(
              labelText: 'Senha',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          SizedBox(height: 15),
          TextField(
            controller: authController.confirmPasswordController, // NOVO: Controller para confirmar senha
            decoration: InputDecoration(
              labelText: 'Confirmar senha',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          SizedBox(height: 20),
          Obx(() => ElevatedButton(
            onPressed: authController.isLoading.value
                ? null // Desabilita o botão enquanto carrega
                : () => authController.registerUser(), // Chama a função de registro
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF5DD9C2), // Cor do botão
              minimumSize: Size(double.infinity, 50), // Botão de largura total
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: authController.isLoading.value
                ? CircularProgressIndicator(color: Colors.white) // Loading
                : Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
          )),
        ],
      ),
    );
  }
}