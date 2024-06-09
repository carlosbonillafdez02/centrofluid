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
  //bool isSaving = false;

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

  // Devuelve una lista de usuarios que son entrenadores
  Future<List<Usuario>> loadEntrenadores() async {
    List<Usuario> entrenadores;
    if (isLoading) {
      loadUsuarios();
    }
    entrenadores =
        usuarios.where((usuario) => usuario.rol == "entrenador").toList();
    return entrenadores;
  }

  // Devuelve una lista de usuarios que son clientes
  Future<List<Usuario>> loadClientes() async {
    List<Usuario> entrenadores;
    if (isLoading) {
      loadUsuarios();
    }
    entrenadores =
        usuarios.where((usuario) => usuario.rol != "entrenador").toList();
    return entrenadores;
  }

  Future<Usuario?> getUsuarioByEmail(String email) async {
    if (isLoading) {
      loadUsuarios();
    }
    var filteredUsers = usuarios.where((u) => u.email == email);
    if (filteredUsers.isNotEmpty) {
      return filteredUsers.first;
    } else {
      return null;
    }
  }

  Future<Usuario> getUsuarioById(String id) async {
    if (isLoading) {
      await loadUsuarios();
    }
    var filteredUsers = usuarios.where((u) => u.id == id);

    return filteredUsers.first;
  }

  Future<String> updateUsuario(Usuario usuario) async {
    final url = Uri.https(_baseURL, 'usuarios/${usuario.id}.json');
    final resp = await http.put(url, body: usuario.toJson());
    // ignore: unused_local_variable
    final decodedData = resp.body;
    return usuario.id!;
  }

  Future<String> updateUsuarioRol(String id, String nuevoRol) async {
    final url = Uri.https(_baseURL, 'usuarios/$id.json');

    final resp = await http.patch(url, body: jsonEncode({'rol': nuevoRol}));
    // ignore: unused_local_variable
    final decodedData = resp.body;

    return id;
  }

  Future<void> updateUserFotoPerfil(String id, String fotoPerfil) async {
    final url =
        Uri.https(_baseURL, 'usuarios/$id.json', {'auth': _firebaseToken});
    final response =
        await http.patch(url, body: json.encode({'fotoPerfil': fotoPerfil}));

    if (response.statusCode == 200) {
      // Update the local user data with the new image path
      final index = usuarios.indexWhere((user) => user.id == id);
      if (index != -1) {
        usuarios[index].fotoPerfil = fotoPerfil;
        notifyListeners();
      }
    } else {
      throw Exception('Failed to update user image path');
    }
  }

  Future<String> saveUsuario(Usuario usuario) async {
    final url = Uri.https(_baseURL, 'usuarios.json');
    final resp = await http.post(url, body: usuario.toJson());
    return resp.body;
  }

  List<Usuario> ordenarUsuarios(List<Usuario> lista) {
    lista.sort((a, b) {
      // Comparamos los nombres ignorando las diferencias entre mayúsculas y minúsculas
      int compareNames =
          a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());

      // Si los nombres son iguales, comparamos los apellidos (si existen)
      if (compareNames == 0) {
        // Si uno de los apellidos es null, lo tratamos como cadena vacía
        String apellidoA = a.apellido ?? "";
        String apellidoB = b.apellido ?? "";
        // Comparamos los apellidos ignorando las diferencias entre mayúsculas y minúsculas
        return apellidoA.toLowerCase().compareTo(apellidoB.toLowerCase());
      }

      return compareNames;
    });
    return lista;
  }
}
