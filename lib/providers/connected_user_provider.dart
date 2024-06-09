import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectedUserProvider extends ChangeNotifier {
  late SharedPreferences _prefs; // Declare SharedPreferences variable
  Usuario activeUser = Usuario(
    email: "test@email.com",
    id: "testid",
    nombre: "test nombre",
    apellido: "test apellido",
    telefono: "000000000",
    direccion: "Calle de la Prueba",
    codigoPostal: "00000",
  );

  // Define el constructor para aceptar SharedPreferences
  ConnectedUserProvider({required SharedPreferences prefs}) {
    _prefs = prefs; // Initialize SharedPreferences variable
  }

  // Método llamado en login_screen si el login se realiza correctamente
  void setActiveUser(Usuario user) {
    //print(user.email);
    activeUser = user;
  }

  // Método para cerrar sesión
  void logout() {
    // Limpiar cualquier información de usuario almacenada
    // Por ejemplo, aquí puedes borrar las credenciales guardadas en SharedPreferences
    _prefs.remove('user');
    _prefs.remove('password');

    // Asignar un nuevo usuario vacío o null según tu lógica de la aplicación
    activeUser = Usuario(
      email: "test@email.com",
      id: "testid",
      nombre: "test nombre",
      apellido: "test apellido",
      telefono: "000000000",
      direccion: "Calle de la Prueba",
      codigoPostal: "00000",
    );

    // Notificar a los escuchadores sobre el cambio
    notifyListeners();
  }
}
