import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart'; // gerado automaticamente pelo Firebase CLI

class FirebaseService {
  static Future<void> inicializarFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (kDebugMode) {
      print('✅ Firebase inicializado com sucesso!');
    }
  }
}
