import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:provider/provider.dart';

class CrearEjercicio extends StatefulWidget {
  @override
  _CrearEjercicioState createState() => _CrearEjercicioState();
}

class _CrearEjercicioState extends State<CrearEjercicio> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _imagenController = TextEditingController();

  List<String> _listaImagenes = [];

  void _agregarImagen() {
    setState(() {
      _listaImagenes.add(_imagenController.text);
      _imagenController.clear();
    });
  }

  void _crearEjercicio() {
    if (_nombreController.text.isNotEmpty && _listaImagenes.isNotEmpty) {
      final nuevoEjercicio = Ejercicio(
        listaImagenes: _listaImagenes,
        nombre: _nombreController.text,
      );

      final ejerciciosService =
          Provider.of<EjerciciosService>(context, listen: false);

      ejerciciosService.createEjercicio(nuevoEjercicio).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ejercicio creado correctamente'),
          ),
        );
        _nombreController.clear();
        _listaImagenes.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear el ejercicio: $error'),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Ejercicio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre del ejercicio'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _imagenController,
              decoration: InputDecoration(labelText: 'URL de la imagen'),
              onSubmitted: (_) => _agregarImagen(),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _agregarImagen,
              child: Text('Agregar Imagen'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Imágenes:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _listaImagenes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_listaImagenes[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: _crearEjercicio,
                child: Text('Crear Ejercicio'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
