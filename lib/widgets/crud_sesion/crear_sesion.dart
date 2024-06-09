import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:provider/provider.dart';

class CrearSesion extends StatefulWidget {
  const CrearSesion({Key? key}) : super(key: key);

  @override
  _CrearSesionState createState() => _CrearSesionState();
}

class _CrearSesionState extends State<CrearSesion> {
  final _sesionNombreController = TextEditingController();
  final List<EjercicioConRepYSeries> _ejerciciosSeleccionados = [];
  late Future<List<Ejercicio>> _futureEjercicios;

  @override
  void initState() {
    super.initState();
    _futureEjercicios = _fetchEjercicios();
  }

  Future<List<Ejercicio>> _fetchEjercicios() async {
    try {
      final ejercicios = await EjerciciosService().loadEjercicios();
      return ejercicios;
    } catch (error) {
      // Manejar errores
      print('Error al cargar los ejercicios: $error');
      return [];
    }
  }

  void _agregarEjercicio(Ejercicio ejercicio, String repeticionesSeries) {
    final ejercicioConRepYSeries = EjercicioConRepYSeries(
      id: ejercicio.id!,
      nombre: ejercicio.nombre,
      repeticionesSeries: repeticionesSeries,
    );
    setState(() {
      _ejerciciosSeleccionados.add(ejercicioConRepYSeries);
    });
  }

  void _eliminarEjercicio(int index) {
    setState(() {
      _ejerciciosSeleccionados.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _sesionNombreController,
              decoration: InputDecoration(
                labelText: 'Nombre de la sesión',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Ejercicios Disponibles:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Ejercicio>>(
                future: _futureEjercicios,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final ejercicios = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: ejercicios.length,
                      itemBuilder: (context, index) {
                        final ejercicio = ejercicios[index];
                        return ListTile(
                          title: Text(ejercicio.nombre),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              _mostrarDialogoAgregarEjercicio(ejercicio);
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Ejercicios Seleccionados:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _ejerciciosSeleccionados.length,
                itemBuilder: (context, index) {
                  final ejercicio = _ejerciciosSeleccionados[index];
                  return ListTile(
                    title: Text(ejercicio.nombre),
                    subtitle: Text(ejercicio.repeticionesSeries),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _eliminarEjercicio(index);
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _crearSesion,
              child: Text('Crear Sesión'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _mostrarDialogoAgregarEjercicio(Ejercicio ejercicio) async {
    final TextEditingController seriesController = TextEditingController();
    final TextEditingController repeticionesController =
        TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Añadir Ejercicio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Series:'),
              TextFormField(
                controller: seriesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ingrese el número de series',
                ),
              ),
              Text('Repeticiones:'),
              TextFormField(
                controller: repeticionesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ingrese el número de repeticiones',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final repeticionesSeries =
                    '${seriesController.text} series X ${repeticionesController.text} repeticiones';
                _agregarEjercicio(ejercicio, repeticionesSeries);
                Navigator.of(context).pop();
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _crearSesion() {
    final nombre = _sesionNombreController.text.trim();
    if (nombre.isNotEmpty && _ejerciciosSeleccionados.isNotEmpty) {
      final nuevaSesion = Sesion(
        nombre: nombre,
        ejercicios: _ejerciciosSeleccionados,
      );

      final sesionesService =
          Provider.of<SesionesService>(context, listen: false);

      sesionesService.createSesion(nuevaSesion).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sesión creada correctamente'),
          ),
        );
        _sesionNombreController.clear();
        _ejerciciosSeleccionados.clear();
        setState(() {});
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear la sesión: $error'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor ingresa un nombre a la sesión y asegúrate de tener al menos un ejercicio seleccionado.',
          ),
        ),
      );
    }
  }
}
