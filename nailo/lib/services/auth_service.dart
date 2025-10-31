import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get usuarioAtual => _auth.currentUser;

  Stream<User?> get usuarioStream => _auth.authStateChanges();

  Future<UserCredential> registrarUsuario(String email, String senha) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
  }

  Future<UserCredential> login(String email, String senha) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> redefinirSenha(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
