import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/screens/screens.dart';

class MiAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /*
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                _navigateToHomeScreen(context);
              },
              child: Image.asset(
                'assets/no-image.jpg', // Cambia la ruta por la de tu logo
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          */
          Spacer(), // Cuando el logo de la empresa está comentado
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                _showBottomSheet(context);
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(
                  'assets/no-image.jpg', // Cambia la ruta por la de tu foto de perfil
                ),
              ),
            ),
          )
        ],
      ),
      //automaticallyImplyLeading: false,
    );
  }

  void _showBottomSheet(BuildContext context) {
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
                },
              ),
              ListTile(
                leading: Icon(Icons.fitness_center),
                title: Text('Ver mis sesiones de entrenamiento'),
                onTap: () {
                  // Aquí se navega a la pantalla de EjerciciosScreen
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Cerrar sesión'),
                onTap: () {
                  // Aquí va la lógica para cerrar sesión
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToHomeScreen(BuildContext context) {
    // Verificar si ya estamos en la pantalla de inicio
    if (ModalRoute.of(context)!.settings.name != '/') {
      // Navegar a la pantalla de inicio solo si no estamos en ella
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
