import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nailo/controllers/auth_controller.dart'; // Usamos o AuthController

class PerfilEditView extends StatelessWidget {
  const PerfilEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    
    // Crie controllers de texto locais pré-preenchidos
    final nomeController = TextEditingController(
      // --- CORREÇÃO AQUI ---
      text: authController.userLogado.value?.nome
    );
    final telefoneController = TextEditingController(
      // --- CORREÇÃO AQUI ---
      text: authController.userLogado.value?.telefone
    );

    return Scaffold(
      appBar: AppBar(title: Text('Editar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: telefoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Aqui você chamaria uma função no AuthController para salvar
                // ex: authController.updateProfile(nomeController.text, telefoneController.text);
                Get.back(); // Volta para a tela de perfil
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}