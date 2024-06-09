import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';
import 'screens.dart';

class AdminScreen extends StatelessWidget {
  final options = [
    'Gestión de Ejercicios',
    'Gestión de Sesiones',
    'Gestión de Grupos',
    'Crear Clase'
  ];

  final screens = [
    EjerciciosScreen(),
    SesionesScreen(),
    GruposScreen(),
    CrearClase(),
  ];

  AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Menú de Gestión'),
          backgroundColor: AppTheme.primary,
          automaticallyImplyLeading: false,
        ),
        body: ListView.separated(
          itemBuilder: (context, index) => ListTile(
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
            title: Text(options[index]),
            onTap: () {
              //Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screens[index]),
              );
            },
          ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: options.length,
        ));
  }
}
