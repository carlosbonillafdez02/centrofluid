import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';

class ModificarGrupo extends StatefulWidget {
  final Grupo grupo;

  const ModificarGrupo({required this.grupo, Key? key}) : super(key: key);

  @override
  _ModificarGrupoState createState() => _ModificarGrupoState();
}

class _ModificarGrupoState extends State<ModificarGrupo> {
  late TextEditingController _nombreGrupoController;
  List<String> _selectedClientes = [];
  List<Usuario> _clientes = [];
  bool _isLoadingClientes = true;

  @override
  void initState() {
    super.initState();
    _nombreGrupoController = TextEditingController(text: widget.grupo.nombre);
    _selectedClientes = List.from(widget.grupo.listaClientes);
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
          title: Text('Modificar Grupo'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Modificar Grupo'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nombreGrupoController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del grupo',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Clientes:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildClientesDropdown(_clientes),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _modificarGrupo,
                  child: Text('Modificar Grupo'),
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

  void _modificarGrupo() {
    if (_nombreGrupoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, ingresa un nombre para el grupo.'),
        ),
      );
      return;
    }

    final nombre = _nombreGrupoController.text;
    final grupoModificado = Grupo(
      id: widget.grupo.id,
      nombre: nombre,
      listaClientes: _selectedClientes,
    );

    final gruposService = Provider.of<GruposService>(context, listen: false);
    gruposService.updateGrupo(grupoModificado);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Grupo modificado correctamente'),
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nombreGrupoController.dispose();
    super.dispose();
  }
}
