import 'dart:convert';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GruposService extends ChangeNotifier {
  final String _baseURL =
      'fl-centrofluid-default-rtdb.europe-west1.firebasedatabase.app';
  final String _firebaseToken = 'GprqMNRkZjSPqhP1RCAIkLx9u5pQnQ89KiM3jFXa';
  final List<Grupo> grupos = [];
  bool isLoading = true;

  GruposService() {
    this.loadGrupos();
  }

  Future<List<Grupo>> loadGrupos() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'grupos.json', {'auth': _firebaseToken});
    final resp = await http.get(url);

    final Map<String, dynamic> gruposMap = json.decode(resp.body);

    // Limpiar la lista de grupos antes de cargar de nuevo todos los grupos
    grupos.clear();

    gruposMap.forEach((key, value) {
      final tempGrupo = Grupo.fromJson(value);
      tempGrupo.id = key;
      this.grupos.add(tempGrupo);
    });

    this.isLoading = false;
    notifyListeners();

    print('REALIZA LOADGRUPOS');

    return this.grupos;
  }

  Future<Grupo> getGrupoById(String id) async {
    final url = Uri.https(_baseURL, 'grupos/$id.json');
    final resp = await http.get(url);

    final Map<String, dynamic> grupoMap = json.decode(resp.body);

    final grupo = Grupo.fromJson(grupoMap);

    return grupo;
  }

  Future<void> createGrupo(Grupo grupo) async {
    final url = Uri.https(_baseURL, 'grupos.json');

    try {
      final resp = await http.post(
        url,
        body: json.encode(grupo.toJson()),
      );

      if (resp.statusCode == 200) {
        this.grupos.add(grupo);
        // Ordenar los grupos alfabéticamente
        grupos.sort(
            (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
        // Notificar a los listeners que los grupos han sido actualizados.
        notifyListeners();
      } else {
        // Manejar la respuesta en caso de que no se haya podido crear el grupo.
        throw Exception('Error al crear el grupo: ${resp.reasonPhrase}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores.
      throw Exception('Error al crear el grupo: $error');
    }
  }

  Future<void> updateGrupo(Grupo grupo) async {
    final url = Uri.https(_baseURL, 'grupos/${grupo.id}.json');

    try {
      final resp = await http.put(
        url,
        body: json.encode(grupo.toJson()),
      );

      if (resp.statusCode == 200) {
        // Encuentra el índice del grupo a actualizar
        final index = grupos.indexWhere((g) => g.id == grupo.id);
        if (index != -1) {
          // Actualiza el grupo en la lista local
          grupos[index] = grupo;
          // Ordenar los grupos alfabéticamente
          grupos.sort((a, b) =>
              a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
          // Notifica a los listeners que los grupos han sido actualizados.
          notifyListeners();
        }
      } else {
        throw Exception('Error al actualizar el grupo: ${resp.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Error al actualizar el grupo: $error');
    }
  }

  Future<void> deleteGrupo(Grupo grupo) async {
    final url = Uri.https(_baseURL, 'grupos/${grupo.id}.json');

    try {
      final resp = await http.delete(url);

      if (resp.statusCode == 200) {
        // Elimina el grupo de la lista local
        grupos.removeWhere((g) => g.id == grupo.id);
        // Notifica a los listeners que los grupos han sido actualizados.
        notifyListeners();
      } else {
        throw Exception('Error al eliminar el grupo: ${resp.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Error al eliminar el grupo: $error');
    }
  }
}
