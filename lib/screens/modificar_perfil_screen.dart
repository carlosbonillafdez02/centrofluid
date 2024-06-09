import 'package:fl_centro_fluid/providers/connected_user_provider.dart';
import 'package:fl_centro_fluid/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:provider/provider.dart';

class ModificarPerfilScreen extends StatefulWidget {
  final Usuario usuario;

  ModificarPerfilScreen({required this.usuario});

  @override
  _ModificarPerfilScreenState createState() => _ModificarPerfilScreenState();
}

class _ModificarPerfilScreenState extends State<ModificarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late Usuario _usuario;

  @override
  void initState() {
    super.initState();
    _usuario = widget.usuario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Perfil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nombre',
                ),
                initialValue: _usuario.nombre,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce tu nombre';
                  }
                  return null;
                },
                onSaved: (value) => _usuario.nombre = value!,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Apellido',
                ),
                initialValue: _usuario.apellido,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce tu apellido';
                  }
                  return null;
                },
                onSaved: (value) => _usuario.apellido = value!,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Dirección',
                ),
                initialValue: _usuario.direccion,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce tu dirección';
                  }
                  return null;
                },
                onSaved: (value) => _usuario.direccion = value!,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Código Postal',
                ),
                initialValue: _usuario.codigoPostal,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce tu código postal';
                  }
                  return null;
                },
                onSaved: (value) => _usuario.codigoPostal = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      // Actualiza los datos del usuario en el servicio
      UsuariosService actualizar = UsuariosService();
      actualizar.updateUsuario(_usuario);
      // Notifica a los widgets que escuchan el ConnectedUserProvider que los datos del usuario han cambiado
      Provider.of<ConnectedUserProvider>(context, listen: false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado correctamente'),
        ),
      );
      Navigator.pop(context);
    }
  }
}
