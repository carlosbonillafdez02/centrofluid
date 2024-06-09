import 'package:fl_centro_fluid/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:provider/provider.dart';

class CrearGrupo extends StatefulWidget {
  @override
  _CrearGrupoState createState() => _CrearGrupoState();
}

class _CrearGrupoState extends State<CrearGrupo> {
  final _capacidadClientesController = TextEditingController();
  final _sesionNombreController = TextEditingController();

  DateTime? _selectedDateTime;
  List<String> _selectedClientes = [];
  List<Usuario> _clientes = [];
  bool _isLoadingClientes = true;

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  Future<void> _loadClientes() async {
    final usuariosService =
        Provider.of<UsuariosService>(context, listen: false);
    List<Usuario> clientes = await usuariosService.loadClientes();
    clientes = usuariosService.ordenarUsuarios(clientes);
    setState(() {
      _clientes = clientes;
      _isLoadingClientes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuariosService = Provider.of<UsuariosService>(context);
    if (usuariosService.isLoading || _isLoadingClientes) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Crear Grupo'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Crear Grupo'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _sesionNombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del grupo',
                  ),
                ),
                /*
                SizedBox(height: 16),
                TextFormField(
                  controller: _capacidadClientesController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Capacidad de Clientes'),
                ),
                */
                SizedBox(height: 16),
                Text(
                  'Clientes:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildClientesDropdown(_clientes),
                /*
                SizedBox(height: 16),
                Text(
                  'Fechas:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildDateTimePicker(),
                */
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _crearGrupo,
                  child: Text('Crear Grupo'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildClientesDropdown(List<Usuario> usuarios) {
    return Column(
      children: usuarios.map((usuario) {
        return CheckboxListTile(
          title: UsuarioCard(usuario: usuario),
          value: _selectedClientes.contains(usuario.id!),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _selectedClientes.add(usuario.id!);
              } else {
                _selectedClientes.remove(usuario.id!);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _selectedDateTime != null
            ? Text(
                'Fecha seleccionada: ${_selectedDateTime!.toLocal()}',
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

  void _crearGrupo() {
    // Verifica si el campo de nombre no está vacío
    if (_sesionNombreController.text.isEmpty) {
      // Si está vacío, muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, ingresa un nombre para el grupo.'),
        ),
      );
      return; // Sale de la función sin crear el grupo
    }

    // Si el nombre no está vacío, continúa con la creación del grupo

    final capacidadClientes =
        int.tryParse(_capacidadClientesController.text) ?? 0;

    /*final List<Fecha> fechas = _selectedDateTime != null
        ? [
            Fecha(
                diaSemana: _selectedDateTime!.weekday,
                hora: _selectedDateTime!.toIso8601String())
          ]
        : [];*/
    final nombre = _sesionNombreController.text;
    final nuevoGrupo = Grupo(
        capacidadClientes: capacidadClientes,
        //fechas: fechas,
        listaClientes: _selectedClientes,
        nombre: nombre);

    final gruposService = Provider.of<GruposService>(context, listen: false);
    gruposService.createGrupo(nuevoGrupo);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Grupo creado correctamente'),
      ),
    );
    _limpiarCampos();
  }

  void _limpiarCampos() {
    _capacidadClientesController.clear();
    _sesionNombreController.clear();
    setState(() {
      _selectedDateTime = null;
      _selectedClientes.clear();
    });
  }
}
