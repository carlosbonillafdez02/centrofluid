import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:http/http.dart' as http;

class UsuariosService extends ChangeNotifier {
  final String _baseURL =
      'fl-centrofluid-default-rtdb.europe-west1.firebasedatabase.app';
  final String _firebaseToken = 'GprqMNRkZjSPqhP1RCAIkLx9u5pQnQ89KiM3jFXa';
  final List<Usuario> usuarios = [];
  Usuario? usuarioSeleccionado;

  bool isLoading = true;
  bool isSaving = false;

  UsuariosService() {
    loadUsuarios();
  }
  Future<List<Usuario>> loadUsuarios() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'usuarios.json', {'auth': _firebaseToken});
    final resp = await http.get(url);

    final Map<String, dynamic> usuariosMap = json.decode(resp.body);

    // Limpiar la lista de usuarios antes de cargar de nuevo todos los usuarios
    usuarios.clear();

    usuariosMap.forEach((key, value) {
      final tempUsuario = Usuario.fromMap(value);
      tempUsuario.id = key;
      this.usuarios.add(tempUsuario);
    });

    this.isLoading = false;
    notifyListeners();

    print('REALIZA LOADUSUARIOS');

    return this.usuarios;
  }

  /*Future<List<Usuario>> loadUsuarios() async {
    notifyListeners();

    final url = Uri.https(_baseURL, 'usuarios.json', {'auth': _firebaseToken});
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final Map<String, dynamic> usuariosMap = json.decode(resp.body);

      this.usuarios.clear();

      usuariosMap.forEach((key, value) {
        final tempUser = Usuario.fromMap(value);
        tempUser.id = key;
        usuarios.add(tempUser);
      });

      return usuarios;
    } else {
      print('La respuesta no es exitosa');
      print('HTTP status: ${resp.statusCode}');
      print('HTTP body: ${resp.body}');
      return [];
    }
  }*/
  /*
  Future<List<Usuario>> loadUsuarios() async {
    isLoading = true;

    //notifyListeners();

    final url = Uri.https(_baseURL, 'usuarios.json', {'auth': _firebaseToken});
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final dynamic responseData = json.decode(resp.body);

      if (responseData is Map<String, dynamic>) {
        this.usuarios.clear();

        responseData.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            final tempUser = Usuario.fromMap(value);
            tempUser.id = key;
            usuarios.add(tempUser);
          }
        });
        isLoading = false;
        notifyListeners();
        print('Realiza loadUsuarios');
        return usuarios;
      } else {
        print('El cuerpo de la respuesta no es un mapa');
        isLoading = false;
        // notifyListeners();
        return [];
      }
    } else {
      print('La respuesta no es exitosa');
      print('HTTP status: ${resp.statusCode}');
      print('HTTP body: ${resp.body}');
      isLoading = false;
      // notifyListeners();
      return [];
    }
  }
*/
  // Devuelve una lista de usuarios que son peluqueros
  Future<List<Usuario>> loadPeluqueros() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'usuarios.json');
    final resp = await http.get(url);

    final Map<String, dynamic> usuariosMap = json.decode(resp.body);

    usuariosMap.forEach((key, value) {
      final tempUser = Usuario.fromMap(value);
    });

    isLoading = false;
    notifyListeners();
    //print(usuarios.toString());
    return usuarios;
  }

  Future<Usuario?> getUsuarioByEmail(String email) async {
    List<Usuario> users = await loadUsuarios();
    var filteredUsers = users.where((u) => u.email == email);
    if (filteredUsers.isNotEmpty) {
      return filteredUsers.first;
    } else {
      return null;
    }
  }

  Future<Usuario?> getUsuarioById(String id) async {
    List<Usuario> users = await loadUsuarios();
    var filteredUsers = users.where((u) => u.id == id);
    if (filteredUsers.isNotEmpty) {
      return filteredUsers.first;
    } else {
      return null;
    }
  }

  Future<String> updateUsuario(Usuario usuario) async {
    final url = Uri.https(_baseURL, 'usuarios/${usuario.id}.json');
    final resp = await http.put(url, body: usuario.toJson());
    final decodedData = resp.body;

    return usuario.id!;
  }

  Future<String> updateUsuarioRol(String id, String nuevoRol) async {
    final url = Uri.https(_baseURL, 'usuarios/$id.json');

    final resp = await http.patch(url, body: jsonEncode({'rol': nuevoRol}));
    final decodedData = resp.body;

    return id;
  }

  Future<String> saveUsuario(Usuario usuario) async {
    final url = Uri.https(_baseURL, 'usuarios.json');
    final resp = await http.post(url, body: usuario.toJson());
    return resp.body;
  }
  /*Future<String> saveUsuario(Map<String, dynamic> data) async {
    final url = Uri.parse(
        'https://cuidadog-f1d5d-default-rtdb.europe-west1.firebasedatabase.app/usuarios.json');
    try {
      final response = await http.post(
        url,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print('Datos insertados correctamente');
        return response.body;
      } else {
        print('Error al insertar datos: ${response.statusCode}');
        return '';
      }
    } catch (error) {
      print('Error al insertar datos: $error');
      return '';
    }
  }*/
}
