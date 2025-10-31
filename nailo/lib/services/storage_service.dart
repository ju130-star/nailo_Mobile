import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImagem(File arquivo, String caminho) async {
    final ref = _storage.ref().child(caminho);
    final uploadTask = await ref.putFile(arquivo);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> deletarArquivo(String caminho) async {
    await _storage.ref().child(caminho).delete();
  }

  Future<String> obterUrl(String caminho) async {
    return await _storage.ref().child(caminho).getDownloadURL();
  }
}
