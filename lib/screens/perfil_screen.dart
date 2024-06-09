import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fl_centro_fluid/providers/providers.dart';
import 'package:fl_centro_fluid/screens/screens.dart';
import 'package:fl_centro_fluid/services/usuarios_service.dart';
import 'package:provider/provider.dart';
import 'package:fl_centro_fluid/models/usuario.dart';
import 'package:fl_centro_fluid/theme/app_theme.dart';
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
    final ConnectedUserProvider connectedUserProvider =
        Provider.of<ConnectedUserProvider>(context);
    final Usuario usuario = connectedUserProvider.activeUser;
    final String userEmail = usuario.email;
    final themeProvider = Provider.of<ThemeProvider>(context);
    usuario.fotoPerfil ??= ""; // para no tener fotoPerfil null

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
                          if (usuario.fotoPerfil!.isNotEmpty)
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: (usuario.fotoPerfil!.isNotEmpty)
                                  ? FileImage(File(usuario.fotoPerfil!))
                                  : null,
                            )
                          else
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: AppTheme.primary,
                              child: Text(
                                '${usuario.nombre[0].toUpperCase()}${usuario.apellido?[0].toUpperCase() ?? ''}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 60,
                                ),
                              ),
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
                        ).then((_) {
                          setState(() {
                            // Force rebuild to reflect changes
                          });
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Modo oscuro  ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Switch(
                              value: themeProvider.isDarkMode,
                              onChanged: (value) {
                                themeProvider.toggleTheme();
                              },
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400),
                          child: Text('Cerrar sesión'),
                          onPressed: () async {
                            await _logout(context);
                          },
                        ),
                      ],
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

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('password');

    Provider.of<ConnectedUserProvider>(context, listen: false).logout();

    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }
}
