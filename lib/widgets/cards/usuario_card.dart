import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';

class UsuarioCard extends StatelessWidget {
  final Usuario usuario;

  const UsuarioCard({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            AvatarUsuario(usuario: usuario,),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${usuario.nombre} ${usuario.apellido ?? ""}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Correo: ${usuario.email}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Teléfono: ${usuario.telefono}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  if (usuario.rol != null)
                    Text(
                      usuario.rol!.toUpperCase(),
                      style: TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
