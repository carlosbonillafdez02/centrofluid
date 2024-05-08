import 'package:fl_centro_fluid/screens/provisionales/crear_ejercicio_screen.dart';
import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';
import 'screens.dart';

class MenuScreen extends StatelessWidget {
  final options = const [EjerciciosScreen(), SesionesScreen(), CrearClase()];

  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pantalla prueba'),
          backgroundColor: AppTheme.primary,
        ),
        body: ListView.separated(
          itemBuilder: (context, index) => ListTile(
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
            title: Text(options[index].toString()),
            onTap: () {
              //Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => options[index]),
              );
            },
          ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: options.length,
        ));
  }
}
