import 'dart:convert';

class Usuario {
  String? id;
  String email;

  String nombre;
  String? apellido;

  String telefono;

  String? direccion;
  String? codigoPostal;

  Usuario({
    this.id,
    required this.email,
    required this.nombre,
    this.apellido,
    required this.telefono,
    this.direccion,
    this.codigoPostal,
  });

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        email: json["email"],
        nombre: json["nombre"],
        apellido: json["apellido"] != null ? json["apellido"] : "",
        telefono: json["telefono"] != null ? json["telefono"].toString() : "",
        direccion: json["direccion"] != null ? json["direccion"] : "",
        codigoPostal:
            json["codigoPostal"] != null ? json["codigoPostal"].toString() : "",
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "nombre": nombre,
        "apellido": apellido,
        "telefono": telefono,
        "direccion": direccion,
        "codigoPostal": codigoPostal,
      };

  Usuario copy() => Usuario(
        id: this.id,
        email: this.email,
        nombre: this.nombre,
        apellido: this.apellido,
        telefono: this.telefono,
        direccion: this.direccion,
        codigoPostal: this.codigoPostal,
      );
}
