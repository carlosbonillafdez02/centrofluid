import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fl_centro_fluid/providers/providers.dart';
import 'package:fl_centro_fluid/screens/screens.dart';
import 'package:fl_centro_fluid/services/usuarios_service.dart';
import 'package:provider/provider.dart';
import 'package:fl_centro_fluid/models/usuario.dart';
import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:fl_centro_fluid/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    final usuariosServices = Provider.of<UsuariosService>(context);
    final Usuario usuario =
        Provider.of<ConnectedUserProvider>(context).activeUser;
    final String userEmail = usuario.email;
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (usuariosServices.isLoading) return LoadingScreen();
    return FutureBuilder<Usuario?>(
      future: usuariosServices.getUsuarioByEmail(userEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Perfil'),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: (usuario.fotoPerfil != null &&
                                    usuario.fotoPerfil!.isNotEmpty)
                                // ? FileImage(File(usuario.fotoPerfil!))
                                ? NetworkImage(usuario.fotoPerfil!)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: () async {
                                  final XFile? selectedImage = await _picker
                                      .pickImage(source: ImageSource.gallery);
                                  if (selectedImage != null) {
                                    // Update the user's image path in the database
                                    await usuariosServices.updateUserFotoPerfil(
                                        usuario.id!, selectedImage.path);
                                    setState(() {
                                      _imageFile = selectedImage;
                                      usuario.fotoPerfil = selectedImage.path;
                                    });
                                  }
                                },
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Nombre'),
                      subtitle: Text(usuario.nombre),
                    ),
                    SizedBox(height: 12),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Apellido'),
                      subtitle: Text(usuario.apellido ?? ''),
                    ),
                    SizedBox(height: 12),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Dirección'),
                      subtitle: Text(usuario.direccion ?? ''),
                    ),
                    SizedBox(height: 12),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text('Código Postal'),
                      subtitle: Text(usuario.codigoPostal ?? ''),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text('Modificar Perfil'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ModificarPerfilScreen(usuario: usuario),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Text('Modo oscuro:'),
                          Switch(
                            value: themeProvider.isDarkMode,
                            onChanged: (value) {
                              themeProvider.toggleTheme();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
