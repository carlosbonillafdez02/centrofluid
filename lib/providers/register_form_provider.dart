import 'package:flutter/material.dart';

class RegisterFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String nombre = '';
  String apellido = '';
  String telefono = '';
  String direccion = '';
  String codigoPostal = '';
  bool verificado = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    //print('$email - $password - $nombre');
    return formKey.currentState?.validate() ?? false;
  }
}
