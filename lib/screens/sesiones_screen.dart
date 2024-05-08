import 'package:fl_centro_fluid/screens/screens.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:fl_centro_fluid/widgets/mi_appbar.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';

class SesionesScreen extends StatefulWidget {
  const SesionesScreen({Key? key}) : super(key: key);

  @override
  State<SesionesScreen> createState() => _SesionesScreenState();
}

class _SesionesScreenState extends State<SesionesScreen> {
  Sesion? _selectedSesion;
  @override
  Widget build(BuildContext context) {
    final sesionesService = Provider.of<SesionesService>(context);

    if (sesionesService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión Sesiones'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CrearSesion()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              if (_selectedSesion != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ModificarSesion(sesion: _selectedSesion!)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selecciona una sesión para modificarla'),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              if (_selectedSesion != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmación'),
                      content: Text(
                          '¿Estás seguro de que quieres eliminar el ejercicio \'${_selectedSesion!.nombre}\'?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar el diálogo
                          },
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            sesionesService.deleteSesion(_selectedSesion!);
                            Navigator.of(context).pop(); // Cerrar el diálogo
                          },
                          child: Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selecciona una sesión para eliminarla'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sesionesService.sesiones.length,
              itemBuilder: (BuildContext context, int index) {
                final sesion = sesionesService.sesiones[index];
                return SesionCard(
                  sesion: sesion,
                  onTap: () {
                    setState(() {
                      _selectedSesion = sesion;
                      print(_selectedSesion!.nombre);
                    });
                  },
                  isSelected: _selectedSesion == sesion,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
