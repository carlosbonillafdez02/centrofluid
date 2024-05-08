import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:provider/provider.dart';

class ModificarEjercicio extends StatefulWidget {
  final Ejercicio ejercicio;

  ModificarEjercicio({required this.ejercicio});

  @override
  _ModificarEjercicioState createState() => _ModificarEjercicioState();
}

class _ModificarEjercicioState extends State<ModificarEjercicio> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController listaImagenesController = TextEditingController();
  // Puedes agregar más controladores para otros campos del ejercicio si es necesario

  @override
  void initState() {
    super.initState();
    // Llenar los controladores con los datos del ejercicio pasado como parámetro
    nombreController.text = widget.ejercicio.nombre;
    listaImagenesController.text = widget.ejercicio.listaImagenes.join(", ");
    // Puedes hacer lo mismo para otros campos si es necesario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Ejercicio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: listaImagenesController,
              decoration: InputDecoration(
                labelText: 'Lista de Imágenes (separadas por coma)',
              ),
            ),
            SizedBox(height: 20),
            // Puedes agregar más campos de entrada para otros atributos del ejercicio si es necesario
            ElevatedButton(
              onPressed: () {
                // Actualizar el ejercicio con los nuevos datos
                final nuevoEjercicio = Ejercicio(
                  id: widget.ejercicio.id,
                  nombre: nombreController.text,
                  listaImagenes: listaImagenesController.text.split(", "),
                  // Puedes agregar más atributos del ejercicio si es necesario
                );

                // Actualizar el ejercicio en el servicio
                Provider.of<EjerciciosService>(context, listen: false)
                    .updateEjercicio(nuevoEjercicio);

                // Volver a la pantalla anterior
                Navigator.pop(context);
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Limpiar los controladores al finalizar
    nombreController.dispose();
    listaImagenesController.dispose();
    super.dispose();
  }
}
