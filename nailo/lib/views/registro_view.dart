import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nailo/controllers/auth_controller.dart';
import 'package:nailo/views/widgets/auth_background.dart';

class RegistroView extends StatelessWidget {
  const RegistroView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return AuthBackground(
      title: 'Cadastro',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: authController.emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: authController.phoneController,
            decoration: const InputDecoration(
              labelText: 'Telefone',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: authController.passwordController,
            decoration: const InputDecoration(
              labelText: 'Senha',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: authController.confirmPasswordController,
            decoration: const InputDecoration(
              labelText: 'Confirmar Senha',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),

          // 🔹 Obx deve envolver apenas o botão que depende de observáveis
          Obx(() {
            final isLoading = authController.isLoading.value;

            return ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => authController.registerUser(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5DD9C2),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Cadastrar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
            );
          }),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Get.back(), // volta pra tela de login
            child: const Text.rich(
              TextSpan(
                text: 'Já possui uma conta? ',
                style: TextStyle(color: Colors.black87),
                children: [
                  TextSpan(
                    text: 'Entrar',
                    style: TextStyle(
                      color: Color(0xFF5DD9C2),
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
