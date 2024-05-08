import 'dart:convert';

import 'package:fl_centro_fluid/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClasesService extends ChangeNotifier {
  final String _baseURL =
      'fl-centrofluid-default-rtdb.europe-west1.firebasedatabase.app';
  final String _firebaseToken = 'GprqMNRkZjSPqhP1RCAIkLx9u5pQnQ89KiM3jFXa';
  final List<Clase> clases = [];
  bool isLoading = true;

  ClasesService() {
    this.loadClases();
  }

  Future<List<Clase>> loadClases() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'clases.json', {'auth': _firebaseToken});
    final resp = await http.get(url);

    final Map<String, dynamic> clasesMap = json.decode(resp.body);

    // Limpiar la lista de clases antes de cargar de nuevo todas las clases
    clases.clear();

    clasesMap.forEach((key, value) {
      final tempClase = Clase.fromJson(value);
      tempClase.id = key;
      this.clases.add(tempClase);
    });

    this.isLoading = false;
    notifyListeners();

    print('REALIZA LOADCLASES');

    return this.clases;
  }

  List<Clase> getClasesDia(DateTime fecha) {
    List<Clase> clasesDia = [];
    if (clases.isNotEmpty) {
      clasesDia.addAll(clases);

      clasesDia.removeWhere((claseDia) =>
          claseDia.fecha.day != fecha.day ||
          claseDia.fecha.month != fecha.month ||
          claseDia.fecha.year != fecha.year);

      clasesDia.sort((a, b) => a.fecha.compareTo(b.fecha));
    }
    return clasesDia;
  }

  Future<void> realizarReservaClase(String claseId, String usuarioId) async {
    final claseIndex = clases.indexWhere((clase) => clase.id == claseId);
    if (claseIndex != -1) {
      clases[claseIndex].listaClientes.add(usuarioId);
      notifyListeners();

      final url = Uri.https(_baseURL, 'clases/$claseId.json');
      await http.patch(url,
          body:
              json.encode({'listaClientes': clases[claseIndex].listaClientes}));
    }
  }

  Future<void> createClase(Clase clase) async {
    final url = Uri.https(_baseURL, 'clases.json', {'auth': _firebaseToken});

    try {
      final resp = await http.post(
        url,
        body: json.encode(clase.toJson()),
      );

      if (resp.statusCode == 200) {
        // Si la solicitud se completó correctamente, actualiza la lista de clases
        final Map<String, dynamic> responseData = json.decode(resp.body);
        final newClaseId = responseData['name'];
        clase.id = newClaseId;
        clases.add(clase);
        notifyListeners();
      } else {
        // Manejar la respuesta en caso de que no se haya podido crear la clase
        throw Exception('Error al crear la clase: ${resp.reasonPhrase}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores
      throw Exception('Error al crear la clase: $error');
    }
  }
}
