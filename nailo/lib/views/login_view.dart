import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nailo/controllers/auth_controller.dart';
import 'package:nailo/views/widgets/auth_background.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return AuthBackground(
      title: 'Login',
      child: SingleChildScrollView(
        // <-- evita o erro de overflow e scrolla o conteúdo
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                controller: authController.passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              // ✅ Obx envolve apenas o que precisa reagir
              Obx(() {
                final isLoading = authController.isLoading.value;
                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => authController.loginUser(),
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
                          'Entrar',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                );
              }),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.toNamed('/registro'),
                child: const Text.rich(
                  TextSpan(
                    text: 'Não possui uma conta? ',
                    style: TextStyle(color: Colors.black87),
                    children: [
                      TextSpan(
                        text: 'Cadastrar',
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
        ),
      ),
    );
  }
}
