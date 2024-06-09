import 'dart:convert';

import 'package:fl_centro_fluid/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SesionesService extends ChangeNotifier {
  final String _baseURL =
      'fl-centrofluid-default-rtdb.europe-west1.firebasedatabase.app';
  final String _firebaseToken = 'GprqMNRkZjSPqhP1RCAIkLx9u5pQnQ89KiM3jFXa';

  final List<Sesion> sesiones = [];
  bool isLoading = true;

  SesionesService() {
    this.loadSesiones();
  }

  Future<List<Sesion>> loadSesiones() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'sesiones.json', {'auth': _firebaseToken});
    final resp = await http.get(url);

    final Map<String, dynamic> sesionesMap = json.decode(resp.body);

    // Limpiar la lista de sesiones antes de cargar de nuevo todas las sesiones
    sesiones.clear();

    sesionesMap.forEach((key, value) {
      final tempSesion = Sesion.fromJson(value);
      tempSesion.id = key;
      this.sesiones.add(tempSesion);
    });

    this.isLoading = false;
    notifyListeners();

    print('REALIZA LOADSESIONES');

    return this.sesiones;
  }

  // Aqui se debería manejar en caso de que no se encuentre la sesión
  Future<Sesion> getSesionById(String id) async {
    final url = Uri.https(_baseURL, 'sesiones/$id.json');
    final resp = await http.get(url);
    final Map<String, dynamic> sesionMap = json.decode(resp.body);

    final sesion = Sesion.fromJson(sesionMap);
    return sesion;
  }

  Future<void> createSesion(Sesion sesion) async {
    final url = Uri.https(_baseURL, 'sesiones.json');

    try {
      final resp = await http.post(
        url,
        body: json.encode(sesion.toJson()),
      );

      if (resp.statusCode == 200) {
        this.sesiones.add(sesion);
        // Notificar a los listeners que las sesiones han sido actualizadas.
        notifyListeners();
      } else {
        // Manejar la respuesta en caso de que no se haya podido crear la sesión.
        throw Exception('Error al crear la sesión: ${resp.reasonPhrase}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores.
      throw Exception('Error al crear la sesión: $error');
    }
  }

  Future<void> updateSesion(Sesion sesion) async {
    final url = Uri.https(_baseURL, 'sesiones/${sesion.id}.json');

    try {
      final resp = await http.put(
        url,
        body: json.encode(sesion.toJson()),
      );

      if (resp.statusCode == 200) {
        final index = sesiones.indexWhere((s) => s.id == sesion.id);
        if (index != -1) {
          sesiones[index] = sesion;
          // Notificar a los listeners que las sesiones han sido actualizadas.
          notifyListeners();
        } else {
          throw Exception(
              'Error al actualizar la sesión: La sesión no se encontró en la lista.');
        }
      } else {
        // Manejar la respuesta en caso de que no se haya podido modificar la sesión.
        throw Exception('Error al actualizar la sesión: ${resp.reasonPhrase}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores.
      throw Exception('Error al actualizar la sesión: $error');
    }
  }

  Future<void> deleteSesion(Sesion sesion) async {
    final url = Uri.https(_baseURL, 'sesiones/${sesion.id}.json');

    try {
      final resp = await http.delete(url);

      if (resp.statusCode == 200) {
        sesiones.removeWhere((s) => s.id == sesion.id);
        // Notificar a los listeners que las sesiones han sido actualizadas.
        notifyListeners();
      } else {
        // Manejar la respuesta en caso de que no se haya podido eliminar la sesión.
        throw Exception('Error al eliminar la sesión: ${resp.reasonPhrase}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores.
      throw Exception('Error al eliminar la sesión: $error');
    }
  }
}
