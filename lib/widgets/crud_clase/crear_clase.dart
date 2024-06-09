import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:fl_centro_fluid/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CrearClase extends StatefulWidget {
  const CrearClase({Key? key}) : super(key: key);

  @override
  _CrearClaseState createState() => _CrearClaseState();
}

class _CrearClaseState extends State<CrearClase> {
  late List<Usuario> _usuarios = [];
  late Usuario _entrenadorSeleccionado =
      Usuario(email: "", nombre: "", telefono: "");
  late List<Sesion> _sesiones = [];
  late Sesion _sesionSeleccionada = Sesion(ejercicios: [], nombre: "");

  late List<Grupo> _grupos = [];
  late Grupo _grupoSeleccionado = Grupo(listaClientes: [], nombre: "");

  final _capacidadClientesController = TextEditingController();
  final _sesionController = TextEditingController();

  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final usuariosService = Provider.of<UsuariosService>(context);
    final sesionesService = Provider.of<SesionesService>(context);
    final gruposService = Provider.of<GruposService>(context);
    if (usuariosService.isLoading ||
        sesionesService.isLoading ||
        gruposService.isLoading) {
      return LoadingScreen();
    } else {
      _sesiones = sesionesService.sesiones;
      _usuarios =
          usuariosService.usuarios.where((u) => u.rol == "entrenador").toList();
      _entrenadorSeleccionado = _usuarios[0];
      _sesionSeleccionada = _sesiones[0];
      _grupos = gruposService.grupos;
      _grupoSeleccionado = _grupos[0];
      return Scaffold(
        appBar: AppBar(
          title: Text('Crear Clase'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _capacidadClientesController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Capacidad de clientes'),
                ),
                Text(
                  'Entrenador:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _buildEntrenadorDropdown(),
                SizedBox(height: 8),
                _buildDateTimePicker(),
                SizedBox(height: 8),
                _buildSesionDropdown(),
                SizedBox(height: 8),
                _buildGrupoDropdown(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _crearClase,
                  child: Text('Crear Clase'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void _crearClase() {
    final capacidadClientes =
        int.tryParse(_capacidadClientesController.text) ?? 0;
    final sesion = _sesionSeleccionada.id;
    //final listaClientes = _listaClientesController.text.split(',');
    final fecha = _selectedDateTime;
    //print('Tamaño lista clientes: ${listaClientes.length}');
    if (capacidadClientes > 0 && fecha != null && sesion!.isNotEmpty
        //&& listaClientes.isNotEmpty
        ) {
      final nuevaClase = Clase(
        capacidadClientes: capacidadClientes,
        entrenador:
            "${_entrenadorSeleccionado.nombre} ${_entrenadorSeleccionado.apellido}",
        fecha: fecha,
        sesion: sesion,
        listaClientes: _grupoSeleccionado.listaClientes,
      );

      final clasesService = ClasesService();
      clasesService.createClase(nuevaClase).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Clase creada correctamente'),
          ),
        );
        _limpiarCampos();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear la clase: $error'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, completa todos los campos correctamente.'),
        ),
      );
    }
  }

  void _limpiarCampos() {
    _capacidadClientesController.clear();
    _sesionController.clear();
    setState(() {
      _selectedDateTime = null;
    });
  }

  Widget _buildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha y Hora:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        _selectedDateTime != null
            ? Text(
                DateFormat('dd/MM/yyyy   HH:mm').format(_selectedDateTime!),
                style: TextStyle(fontSize: 16),
              )
            : SizedBox(),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: _showDateTimePicker,
          child: Text('Seleccionar Fecha y Hora'),
        ),
      ],
    );
  }

  Future<void> _showDateTimePicker() async {
    final initialDate = _selectedDateTime ?? DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (newDate != null) {
      final newTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (newTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            newDate.year,
            newDate.month,
            newDate.day,
            newTime.hour,
            newTime.minute,
          );
        });
      }
    }
  }

  Widget _buildEntrenadorDropdown() {
    return DropdownButtonFormField<Usuario>(
      value: _entrenadorSeleccionado,
      items: _usuarios.map((usuario) {
        return DropdownMenuItem<Usuario>(
          value: usuario,
          child: Text('${usuario.nombre} ${usuario.apellido}'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _entrenadorSeleccionado = value!;
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Seleccionar entrenador',
      ),
    );
  }

  Widget _buildSesionDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sesión:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<Sesion>(
          value: _sesionSeleccionada,
          items: _sesiones.map((sesion) {
            return DropdownMenuItem<Sesion>(
              value: sesion,
              child: Text(sesion.nombre),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _sesionSeleccionada = value!;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Seleccionar sesión',
          ),
        ),
      ],
    );
  }

  Widget _buildGrupoDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grupo:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<Grupo>(
          value: _grupoSeleccionado,
          items: _grupos.map((grupo) {
            return DropdownMenuItem<Grupo>(
              value: grupo,
              child: Text(grupo.nombre),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _grupoSeleccionado = value!;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Seleccionar grupo',
          ),
        ),
      ],
    );
  }
}
