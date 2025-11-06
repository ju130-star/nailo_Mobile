import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nailo/controllers/user/user_historico_controller.dart';
import 'package:nailo/views/widgets/historico_card.dart'; // O novo card

class UserHistoricoView extends StatelessWidget {
  const UserHistoricoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserHistoricoController controller = Get.put(UserHistoricoController());
    const Color corPrincipal = Color(0xFF5DD9C2);
    const Color corFundo = Color(0xFFC5F3F4);

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corPrincipal,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.style, color: Colors.black), // Logo
            SizedBox(width: 8),
            Text('Nailo', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // --- Barra de Busca ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Buscar no histórico...',
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade700),
                  suffixIcon: Obx(() => controller.isSearching.value
                      ? IconButton(
                          icon: Icon(Icons.close, color: Colors.grey.shade700),
                          onPressed: controller.clearSearch,
                        )
                      : SizedBox.shrink()),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // --- Conteúdo (Busca ou Listas) ---
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator(color: corPrincipal));
                }
                
                // --- Se estiver buscando ---
                if (controller.isSearching.value) {
                  if (controller.listaBusca.isEmpty) {
                    return Center(child: Text('Nenhum resultado encontrado.'));
                  }
                  return ListView.builder(
                    itemCount: controller.listaBusca.length,
                    itemBuilder: (context, index) {
                      return HistoricoCard(agendamento: controller.listaBusca[index]);
                    },
                  );
                }

                // --- Se não estiver buscando (Visão Padrão) ---
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Recentes ---
                      Text(
                        'Recentes',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      SizedBox(height: 8),
                      if (controller.historicoRecente.isEmpty)
                        Text('Nenhum agendamento recente.')
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.historicoRecente.length,
                          itemBuilder: (context, index) {
                            return HistoricoCard(agendamento: controller.historicoRecente[index]);
                          },
                        ),
                      
                      SizedBox(height: 24),

                      // --- Há Meses ---
                      Text(
                        'Há meses',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      SizedBox(height: 8),
                      if (controller.historicoAntigo.isEmpty)
                        Text('Nenhum agendamento antigo.')
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.historicoAntigo.length,
                          itemBuilder: (context, index) {
                            return HistoricoCard(agendamento: controller.historicoAntigo[index]);
                          },
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: corPrincipal,
        selectedItemColor: Colors.pink.shade700,
        unselectedItemColor: Colors.black.withOpacity(0.6),
        currentIndex: 2, // 2 é o índice do "Histórico" (ou Apps)
        onTap: (index) {
          if (index == 0) Get.offNamed('/user_home');
          if (index == 1) Get.toNamed('/user_agenda');
          if (index == 3) Get.toNamed('/perfil');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'), // Ícone atualizado
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}