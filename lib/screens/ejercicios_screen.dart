import 'package:fl_centro_fluid/screens/screens.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';
import 'package:fl_centro_fluid/models/models.dart';

class EjerciciosScreen extends StatefulWidget {
  const EjerciciosScreen({Key? key}) : super(key: key);

  @override
  _EjerciciosScreenState createState() => _EjerciciosScreenState();
}

class _EjerciciosScreenState extends State<EjerciciosScreen> {
  Ejercicio? _selectedEjercicio;

  @override
  Widget build(BuildContext context) {
    final ejerciciosService = Provider.of<EjerciciosService>(context);

    if (ejerciciosService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión Ejercicios'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CrearEjercicio()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              if (_selectedEjercicio != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ModificarEjercicio(ejercicio: _selectedEjercicio!)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selecciona un ejercicio para modificarlo'),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              if (_selectedEjercicio != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmación'),
                      content: Text(
                          '¿Estás seguro de que quieres eliminar el ejercicio \'${_selectedEjercicio!.nombre}\'?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar el diálogo
                          },
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            ejerciciosService
                                .deleteEjercicio(_selectedEjercicio!);
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
                    content: Text('Selecciona un ejercicio para eliminarlo'),
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
              itemCount: ejerciciosService.ejercicios.length,
              itemBuilder: (BuildContext context, int index) {
                final ejercicio = ejerciciosService.ejercicios[index];
                return EjercicioCard(
                  ejercicio: ejercicio,
                  onTap: () {
                    setState(() {
                      _selectedEjercicio = ejercicio;
                      print(_selectedEjercicio!.nombre);
                    });
                  },
                  isSelected: _selectedEjercicio == ejercicio,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
