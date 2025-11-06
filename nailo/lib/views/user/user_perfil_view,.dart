import 'package:flutter/material.dart';
import 'package:get/get.dart';
// O nome do seu controller pode ser 'perfil_controller.dart' ou 'user/user_perfil_controller.dart'
// Ajuste o import se necessário
import 'package:nailo/controllers/perfil_controller.dart'; 

class PerfilView extends StatelessWidget {
  const PerfilView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PerfilController controller = Get.put(PerfilController());
    
    const Color corPrincipal = Color(0xFF5DD9C2);
    const Color corFundo = Color(0xFFC5F3F4);
    const Color corTextoBotao = Colors.white; 
    const Color corCard = Colors.white;

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corPrincipal,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.style, color: Colors.black), // Ícone de "Logo"
            SizedBox(width: 8),
            Text(
              'Nailo',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: corCard,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.grey.shade700,
                  ),
                  SizedBox(height: 16),
                  
                  Text('Nome', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  Obx(() => Text(
                    // --- CORREÇÃO AQUI ---
                    // Mudamos de .nome para ['nome']
                    controller.authController.userLogado.value?.nome ?? 'Carregando...',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  
                  SizedBox(height: 16),
                  
                  Text('Telefone', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  Obx(() => Text(
                    // --- CORREÇÃO AQUI ---
                    // Mudamos de .telefone para ['telefone']
                    controller.authController.userLogado.value?.telefone ?? 'Não informado',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  
                  SizedBox(height: 24),
                  
                  ElevatedButton(
                    onPressed: controller.onEditPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corPrincipal,
                      foregroundColor: corTextoBotao,
                      minimumSize: Size(150, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Editar', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            
            Spacer(), 
            
            ElevatedButton(
              onPressed: controller.onLogoutPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: corPrincipal,
                foregroundColor: corTextoBotao,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Sair', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: corPrincipal,
        selectedItemColor: Colors.pink.shade700,
        unselectedItemColor: Colors.black.withOpacity(0.6),
        currentIndex: 3, 
        onTap: (index) {
          if (index == 0) Get.offNamed('/user_home');
          if (index == 1) Get.toNamed('/user_agenda');
          if (index == 2) Get.toNamed('/user_historico');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.phone_android), label: 'Apps'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}