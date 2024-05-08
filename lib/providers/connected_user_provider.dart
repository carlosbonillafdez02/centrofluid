import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/usuario.dart';

class ConnectedUserProvider extends ChangeNotifier {
  //prueba
  Usuario activeUser = Usuario(
    email: "test@email.com",
    id: "testid",
    nombre: "test nombre",
    apellido: "test apellido",
    telefono: "000000000",
    direccion: "Calle de la Prueba",
    codigoPostal: "00000",
  );

  // Método llamado en login_screen si el login se realiza correctamente
  void setActiveUser(Usuario user) {
    //print(user.email);
    activeUser = user;
  }

  void logout() {}
}
