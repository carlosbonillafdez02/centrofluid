import 'dart:convert';

class Usuario {
  String? id;
  String email;
  String nombre;
  String? apellido;
  String telefono;
  String? direccion;
  String? codigoPostal;
  String? fotoPerfil;
  String? rol;

  Usuario({
    this.id,
    required this.email,
    required this.nombre,
    this.apellido,
    required this.telefono,
    this.direccion,
    this.codigoPostal,
    this.fotoPerfil,
    this.rol,
  });

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        email: json["email"],
        nombre: json["nombre"],
        apellido: json["apellido"] ?? "",
        telefono: json["telefono"] != null ? json["telefono"].toString() : "",
        direccion: json["direccion"] ?? "",
        codigoPostal:
            json["codigoPostal"] != null ? json["codigoPostal"].toString() : "",
        fotoPerfil: json["fotoPerfil"] != null ? json["fotoPerfil"] : "",
        rol: json["rol"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "nombre": nombre,
        "apellido": apellido,
        "telefono": telefono,
        "direccion": direccion,
        "codigoPostal": codigoPostal,
        "fotoPerfil": fotoPerfil,
        "rol": rol,
      };

  Usuario copy() => Usuario(
        id: id,
        email: email,
        nombre: nombre,
        apellido: apellido,
        telefono: telefono,
        direccion: direccion,
        codigoPostal: codigoPostal,
        fotoPerfil: fotoPerfil,
        rol: rol,
      );
}
