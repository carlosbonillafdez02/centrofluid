import 'dart:convert';

import 'package:fl_centro_fluid/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EjerciciosService extends ChangeNotifier {
  final String _baseURL =
      'fl-centrofluid-default-rtdb.europe-west1.firebasedatabase.app';
  final String _firebaseToken = 'GprqMNRkZjSPqhP1RCAIkLx9u5pQnQ89KiM3jFXa';

  final List<Ejercicio> ejercicios = [];
  bool isLoading = true;

  EjerciciosService() {
    this.loadEjercicios();
  }

  Future<List<Ejercicio>> loadEjercicios() async {
    this.isLoading = true;
    notifyListeners();

    final url =
        Uri.https(_baseURL, 'ejercicios.json', {'auth': _firebaseToken});
    final resp = await http.get(url);

    final Map<String, dynamic> ejerciciosMap = json.decode(resp.body);

    // Limpiar la lista de ejercicios antes de cargar de nuevo todos los usuarios
    ejercicios.clear();

    ejerciciosMap.forEach((key, value) {
      final tempEjercicio = Ejercicio.fromJson(value);
      tempEjercicio.id = key;
      this.ejercicios.add(tempEjercicio);
    });

    // Ordenar los ejercicios alfabéticamente
    ejercicios.sort(
        (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
    this.isLoading = false;
    notifyListeners();

    print('Realiza LOADEJERCICIOS');
    return this.ejercicios;
  }

  // Aqui se debería manejar en caso de que no se encuentre el ejercicio
  Future<Ejercicio> getEjercicioById(String id) async {
    final url = Uri.https(_baseURL, 'ejercicios/$id.json');
    final resp = await http.get(url);

    final Map<String, dynamic> ejercicioMap = json.decode(resp.body);

    final ejercicio = Ejercicio.fromJson(ejercicioMap);

    return ejercicio;
  }

  Future<void> createEjercicio(Ejercicio ejercicio) async {
    final url = Uri.https(_baseURL, 'ejercicios.json');

    try {
      final resp = await http.post(
        url,
        body: json.encode(ejercicio.toJson()),
      );

      if (resp.statusCode == 200) {
        // Si la solicitud se completó correctamente, puedes actualizar la lista de ejercicios o hacer cualquier otra acción necesaria.
        // Por ejemplo, si deseas cargar los ejercicios actualizados después de agregar uno nuevo, puedes llamar a loadEjercicios() nuevamente.
        this.ejercicios.add(ejercicio);
        // Ordenar los ejercicios alfabéticamente
        ejercicios.sort(
            (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
        // También puedes notificar a los listeners que los ejercicios han sido actualizados.
        notifyListeners();
      } else {
        // Manejar la respuesta en caso de que no se haya podido crear el ejercicio.
        throw Exception('Error al crear el ejercicio: ${resp.reasonPhrase}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores.
      throw Exception('Error al crear el ejercicio: $error');
    }
  }

  Future<void> updateEjercicio(Ejercicio ejercicio) async {
    final url = Uri.https(_baseURL, 'ejercicios/${ejercicio.id}.json');

    try {
      final resp = await http.put(
        url,
        body: json.encode(ejercicio.toJson()),
      );

      if (resp.statusCode == 200) {
        // Si la solicitud se completó correctamente, puedes actualizar la lista de ejercicios o hacer cualquier otra acción necesaria.
        // Por ejemplo, si deseas cargar los ejercicios actualizados después de modificar uno, puedes llamar a loadEjercicios() nuevamente.
        final index = ejercicios.indexWhere((e) => e.id == ejercicio.id);
        if (index != -1) {
          ejercicios[index] = ejercicio;
          // Ordenar los ejercicios alfabéticamente
          ejercicios.sort((a, b) =>
              a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
          // También puedes notificar a los listeners que los ejercicios han sido actualizados.
          notifyListeners();
        } else {
          throw Exception(
              'Error al actualizar el ejercicio: El ejercicio no se encontró en la lista.');
        }
      } else {
        // Manejar la respuesta en caso de que no se haya podido modificar el ejercicio.
        throw Exception(
            'Error al actualizar el ejercicio: ${resp.reasonPhrase}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores.
      throw Exception('Error al actualizar el ejercicio: $error');
    }
  }

  Future<void> deleteEjercicio(Ejercicio ejercicio) async {
    final url = Uri.https(_baseURL, 'ejercicios/${ejercicio.id}.json');

    try {
      final resp = await http.delete(url);

      if (resp.statusCode == 200) {
        // Si la solicitud se completó correctamente, puedes actualizar la lista de ejercicios o hacer cualquier otra acción necesaria.
        // Por ejemplo, si deseas cargar los ejercicios actualizados después de eliminar uno, puedes llamar a loadEjercicios() nuevamente.
        ejercicios.removeWhere((e) => e.id == ejercicio.id);
        // También puedes notificar a los listeners que los ejercicios han sido actualizados.
        notifyListeners();
      } else {
        // Manejar la respuesta en caso de que no se haya podido eliminar el ejercicio.
        throw Exception('Error al eliminar el ejercicio: ${resp.reasonPhrase}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores.
      throw Exception('Error al eliminar el ejercicio: $error');
    }
  }
}
