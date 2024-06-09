import 'package:fl_centro_fluid/screens/screens.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fl_centro_fluid/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:fl_centro_fluid/models/usuario.dart';
import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MiAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final Usuario usuario =
        Provider.of<ConnectedUserProvider>(context).activeUser;
    usuario.fotoPerfil ??= ""; // para no tener fotoPerfil null
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/logo-centro-invertido.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          Spacer(),
          if (usuario.fotoPerfil!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    _showBottomSheet(context, usuario);
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: (usuario.fotoPerfil != null &&
                            usuario.fotoPerfil!.isNotEmpty)
                        ? FileImage(File(usuario.fotoPerfil!))
                        // ? NetworkImage(usuario.fotoPerfil!)
                        : null,
                  )),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  _showBottomSheet(context, usuario);
                },
                child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Text(
                      '${usuario.nombre[0].toUpperCase()}${usuario.apellido![0].toUpperCase()}', // Iniciales del nombre y apellido
                      style: TextStyle(color: AppTheme.primary),
                    )),
              ),
            ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }

  void _showBottomSheet(BuildContext context, Usuario usuario) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Editar perfil'),
                onTap: () {
                  // Aquí va la lógica para editar el perfil
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ModificarPerfilScreen(usuario: usuario)),
                  );
                },
              ),
              /* FUTURA IMPLEMENTACIÓN
              ListTile(
                leading: Icon(Icons.fitness_center),
                title: Text('Ver mis sesiones de entrenamiento'),
                onTap: () {
                  // Aquí se navega a la pantalla de EjerciciosScreen
                  Navigator.pop(context);
                },
              ),
              */
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Cerrar sesión'),
                onTap: () {
                  // Aquí va la lógica para cerrar sesión
                  _logout(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    // Elimina las credenciales almacenadas (si es necesario)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('password');

    // Restablece el usuario activo
    Provider.of<ConnectedUserProvider>(context, listen: false).logout();

    // Luego, navegar a la pantalla de inicio de sesión
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
