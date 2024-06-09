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

  Future<Clase> getClaseById(String id) async {
    final url = Uri.https(_baseURL, 'clases/$id.json');
    final resp = await http.get(url);

    final Map<String, dynamic> claseMap = json.decode(resp.body);

    final clase = Clase.fromJson(claseMap);

    return clase;
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

  Future<bool> realizarReservaClase(String claseId, String usuarioId) async {
    final Clase? clase = await getClaseById(claseId);

    // Verifica que la clase no sea nula
    if (clase == null) {
      return false; // Devuelve `false` si no se encuentra la clase
    }

    // Verifica la capacidad de la clase y si se puede añadir el usuario
    if (clase.capacidadClientes > clase.listaClientes.length) {
      clase.listaClientes.add(usuarioId);
      notifyListeners();

      final url =
          Uri.https(_baseURL, 'clases/$claseId.json', {'auth': _firebaseToken});
      await http.patch(url,
          body: json.encode({'listaClientes': clase.listaClientes}));

      // posición donde se encuentra la clase en la lista
      final index = clases.indexWhere((element) => element.id == claseId);
      clases[index].listaClientes.add(usuarioId);
      notifyListeners();

      return true;
    } else {
      return false;
    }
  }

  Future<bool> cancelarReservaClase(String claseId, String usuarioId) async {
    final Clase? clase = await getClaseById(claseId);

    // Verifica que la clase no sea nula
    if (clase == null) {
      return false;
    }

    // Verifica si el usuario está en la lista de clientes
    if (clase.listaClientes.contains(usuarioId)) {
      clase.listaClientes.remove(usuarioId);
      notifyListeners();

      final url =
          Uri.https(_baseURL, 'clases/$claseId.json', {'auth': _firebaseToken});
      await http.patch(url,
          body: json.encode({'listaClientes': clase.listaClientes}));

      // posición donde se encuentra la clase en la lista
      final index = clases.indexWhere((element) => element.id == claseId);
      clases[index].listaClientes.remove(usuarioId);
      notifyListeners();

      return true;
    } else {
      return false;
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

  Future<void> deleteClase(Clase clase) async {
    final url = Uri.https(
        _baseURL, 'clases/${clase.id}.json', {'auth': _firebaseToken});
    await http.delete(url);

    clases.removeWhere((element) => element.id == clase.id);
    notifyListeners();
  }

  Future<List<Clase>> getAllClasesActuales() async {
    List<Clase> clienteClases = [];
    DateTime now = DateTime.now();

    for (Clase clase in clases) {
      if (clase.fecha.isAfter(now) || clase.isSameDay(now, clase.fecha)) {
        clienteClases.add(clase);
      }
    }

    // Ordenar las clases por fecha (de más recientes a menos recientes)
    clienteClases.sort((a, b) => a.fecha.compareTo(b.fecha));

    return clienteClases;
  }

  Future<List<Clase>> getAllClasesPasadas() async {
    List<Clase> clienteClases = [];
    DateTime now = DateTime.now();
    for (Clase clase in clases) {
      if (clase.fecha.isBefore(now) && !clase.isSameDay(now, clase.fecha)) {
        clienteClases.add(clase);
      }
    }

    // Ordenar las clases por fecha (de más recientes a menos recientes)
    clienteClases.sort((a, b) => b.fecha.compareTo(a.fecha));

    return clienteClases;
  }

  Future<List<Clase>> getClienteClasesActuales(String idUsuario) async {
    List<Clase> clienteClases = [];
    DateTime now = DateTime.now();

    for (Clase clase in clases) {
      if (clase.listaClientes.contains(idUsuario)) {
        if (clase.fecha.isAfter(now) || clase.isSameDay(now, clase.fecha)) {
          clienteClases.add(clase);
        }
      }
    }

    // Ordenar las clases por fecha (de más recientes a menos recientes)
    clienteClases.sort((a, b) => a.fecha.compareTo(b.fecha));

    return clienteClases;
  }

  Future<List<Clase>> getClienteClasesPasadas(String idUsuario) async {
    List<Clase> clienteClases = [];
    DateTime now = DateTime.now();
    for (Clase clase in clases) {
      if (clase.listaClientes.contains(idUsuario)) {
        if (clase.fecha.isBefore(now) && !clase.isSameDay(now, clase.fecha)) {
          clienteClases.add(clase);
        }
      }
    }

    // Ordenar las clases por fecha (de más recientes a menos recientes)
    clienteClases.sort((a, b) => b.fecha.compareTo(a.fecha));

    return clienteClases;
  }

  bool isReservedByClient(Clase clase, String idUsuario) {
    return clase.listaClientes.contains(idUsuario);
  }
}
