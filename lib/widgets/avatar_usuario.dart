import 'dart:io';
import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';

class AvatarUsuario extends StatelessWidget {
  final Usuario usuario;

  const AvatarUsuario({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? fotoPerfilUrl = usuario.fotoPerfil ?? "";
    // Si no hay foto de perfil, usa iniciales del nombre y apellido
    if (fotoPerfilUrl.isNotEmpty) {
      // Si hay una URL de imagen válida, muestra la imagen
      return CircleAvatar(
        radius: 20,
        backgroundColor: AppTheme.primary,
        backgroundImage: FileImage(File(fotoPerfilUrl)),
      );
    } else {
      // Si no hay foto de perfil, muestra iniciales
      return CircleAvatar(
        radius: 20,
        backgroundColor:
            AppTheme.primary,
        child: Text(
          '${usuario.nombre[0].toUpperCase()}${usuario.apellido?[0].toUpperCase() ?? ""}', // Iniciales del nombre y apellido
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
