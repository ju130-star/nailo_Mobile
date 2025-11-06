import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nailo/models/user_model.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();

  var isLoading = false.obs;

  // Armazena o usuário logado
  var userLogado = Rxn<UserModel>();

  /// === LOGIN ===
  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Erro', 'Preencha todos os campos');
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));

      // Login de teste
      if (email == 'teste@email.com' && password == '123456') {
        userLogado.value = UserModel(
  id: '1',
  nome: 'Usuário Teste',
  email: email,
  telefone: '11999999999',
  tipo: 'cliente', // ✅ adicionado
);


        Get.offAllNamed('/home'); // ✅ vai pra home
      } else {
        Get.snackbar('Erro', 'Usuário ou senha inválidos');
      }
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// === REGISTRO ===
  Future<void> registerUser() async {
    final nome = nameController.text.trim();
    final email = emailController.text.trim();
    final telefone = phoneController.text.trim();
    final senha = passwordController.text.trim();
    final confirmSenha = confirmPasswordController.text.trim();

    if ([nome, email, telefone, senha, confirmSenha].any((e) => e.isEmpty)) {
      Get.snackbar('Erro', 'Preencha todos os campos');
      return;
    }

    if (senha != confirmSenha) {
      Get.snackbar('Erro', 'As senhas não coincidem');
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));

      userLogado.value = UserModel(
  id: '2',
  nome: nome,
  email: email,
  telefone: telefone,
  tipo: 'cliente', // ✅ adicionado
);


      Get.snackbar('Sucesso', 'Cadastro realizado com sucesso!');
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// === LOGOUT ===
  void logout() {
    userLogado.value = null;
    emailController.clear();
    passwordController.clear();
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
