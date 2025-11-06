import 'package:flutter/material.dart';
import 'package:nailo/models/profissional_model.dart';


class ProfissionalAvatar extends StatelessWidget {
  final ProfissionalModel profissional;
  final VoidCallback? onTap;

  const ProfissionalAvatar({
    Key? key,
    required this.profissional,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80, // Largura fixa para o item
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.pink.shade100, // Cor de fundo do avatar
              backgroundImage: profissional.fotoUrl != null
                  ? NetworkImage(profissional.fotoUrl!) // Carrega a imagem da rede
                  : null,
              child: profissional.fotoUrl == null
                  ? Icon(Icons.person, size: 30, color: Colors.pink.shade700) // Ícone padrão
                  : null,
            ),
            SizedBox(height: 6),
            Text(
              profissional.nome.split(' ')[0], // Mostra só o primeiro nome
              style: TextStyle(fontSize: 12, color: Colors.black87),
              overflow: TextOverflow.ellipsis, // Evita quebra de linha
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}