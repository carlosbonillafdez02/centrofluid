import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:provider/provider.dart';

class ModificarSesion extends StatefulWidget {
  final Sesion sesion;

  const ModificarSesion({Key? key, required this.sesion}) : super(key: key);

  @override
  _ModificarSesionState createState() => _ModificarSesionState();
}

class _ModificarSesionState extends State<ModificarSesion> {
  final TextEditingController _nombreController = TextEditingController();
  final List<EjercicioConRepYSeries> _ejerciciosModificados = [];

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.sesion.nombre;
    _ejerciciosModificados.addAll(widget.sesion.ejercicios);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre de la sesión',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Ejercicios:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _ejerciciosModificados.length,
                itemBuilder: (context, index) {
                  final ejercicio = _ejerciciosModificados[index];
                  final TextEditingController seriesController =
                      TextEditingController();
                  final TextEditingController repeticionesController =
                      TextEditingController();

                  // Desglosar repeticiones y series si están disponibles
                  if (ejercicio.repeticionesSeries.contains('series X')) {
                    final parts =
                        ejercicio.repeticionesSeries.split('series X');
                    if (parts.length == 2) {
                      seriesController.text = parts[0].trim();
                      repeticionesController.text =
                          parts[1].trim().replaceAll('repeticiones', '').trim();
                    }
                  }

                  return ListTile(
                    title: Text(ejercicio.nombre),
                    subtitle: Column(
                      children: [
                        TextFormField(
                          controller: seriesController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Series',
                          ),
                          onChanged: (value) {
                            _ejerciciosModificados[index].repeticionesSeries =
                                '$value series X ${repeticionesController.text} repeticiones';
                          },
                        ),
                        TextFormField(
                          controller: repeticionesController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Repeticiones',
                          ),
                          onChanged: (value) {
                            _ejerciciosModificados[index].repeticionesSeries =
                                '${seriesController.text} series X $value repeticiones';
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _guardarCambios,
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  void _guardarCambios() {
    final nombre = _nombreController.text.trim();
    if (nombre.isNotEmpty && _ejerciciosModificados.isNotEmpty) {
      final sesionModificada = Sesion(
        id: widget.sesion.id,
        nombre: nombre,
        ejercicios: _ejerciciosModificados,
      );

      final sesionesService =
          Provider.of<SesionesService>(context, listen: false);

      sesionesService.updateSesion(sesionModificada).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sesión modificada correctamente'),
          ),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al modificar la sesión: $error'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor ingresa un nombre y modifica al menos un ejercicio.',
          ),
        ),
      );
    }
  }
}
