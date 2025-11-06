import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nailo/controllers/auth_controller.dart'; // Seu AuthController
import 'package:nailo/views/widgets/auth_background.dart';
import 'package:nailo/widgets/auth_background.dart'; // O widget de background

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pegar a instância do AuthController que já foi injetada no main.dart
    final AuthController authController = Get.find<AuthController>();

    return AuthBackground(
      title: 'Login', // Título para o card
      child: Column(
        children: [
          TextField(
            controller: authController.emailController, // Associa ao controller
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 15),
          TextField(
            controller: authController.passwordController, // Associa ao controller
            decoration: InputDecoration(
              labelText: 'Senha',
              border: OutlineInputBorder(),
            ),
            obscureText: true, // Para esconder a senha
          ),
          SizedBox(height: 20),
          Obx(() => ElevatedButton(
            onPressed: authController.isLoading.value
                ? null // Desabilita o botão enquanto carrega
                : () => authController.loginUser(), // Chama a função de login
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
                    'Entrar',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
          )),
          SizedBox(height: 20),
          TextButton(
            onPressed: () => Get.toNamed('/registro'), // Navega para a tela de registro
            child: Text.rich(
              TextSpan(
                text: 'Não possui uma conta? ',
                style: TextStyle(color: Colors.black87),
                children: [
                  TextSpan(
                    text: 'Cadastrar',
                    style: TextStyle(
                      color: Color(0xFF5DD9C2), // Cor do link
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}