import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:nailo/controllers/auth_controller.dart';
import 'package:nailo/services/api_service.dart';
import 'package:nailo/views/login_view.dart';
import 'package:nailo/views/registro_view.dart';
import 'package:nailo/views/user/user_home_view.dart'; // Importe sua Home View
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
        // ... (suas outras rotas: user_home, proprietario_home, perfil, etc.) ...
      ],
    );
  }
}