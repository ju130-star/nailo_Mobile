import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:nailo/controllers/auth_controller.dart';
import 'package:nailo/controllers/perfil_controller.dart';
import 'package:nailo/controllers/user/user_novo_agendamento_controller.dart';
import 'package:nailo/services/api_service.dart';
import 'package:nailo/views/login_view.dart';
import 'package:nailo/views/registro_view.dart';
import 'package:nailo/views/user/user_home_view.dart'; // Importe sua Home View
import 'package:nailo/views/user/user_novo_agendamento_view.dart';
import 'package:nailo/views/user/user_perfil_edit_view.dart';
import 'package:nailo/views/user/user_perfil_view,.dart';
import 'services/firebase_service.dart'; // Importe seu serviço Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


Get.put(ApiService(), permanent: true);
  Get.put(AuthController(), permanent: true);

  // (Descomente quando o FirebaseService estiver 100% configurado)
  // await FirebaseService.inicializarFirebase(); 
  
  // A função runApp() é chamada UMA VEZ
  // O MaterialApp vai DENTRO dela
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'nailo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ... (seu tema) ...
      ),

      initialRoute: '/login', // O app começa na tela de Login

      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginView(),
          // O AuthController já é global, não precisa de binding aqui
        ),
        GetPage(
          name: '/registro',
          page: () => const RegistroView(),
          // O AuthController já é global, não precisa de binding aqui
        ),
         GetPage(
          name: '/home', 
          page: () => const UserHomeView()
          ),
          GetPage(
          name: '/perfil',
          page: () => const PerfilView(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => PerfilController());
          }),
          ),
          GetPage(
          name: '/perfil_edit',
          page: () => const PerfilEditView(),
  // Não precisa de controller novo se for simples
         ),
         GetPage(
         name: '/user_novo_agendamento',
         page: () => const UserNovoAgendamentoView(),
         binding: BindingsBuilder(() {
         Get.lazyPut(() => UserNovoAgendamentoController());
  }),
),
        // ... (suas outras rotas: user_home, proprietario_home, perfil, etc.) ...
      ],
    );
  }
}