import 'dart:convert';

class Ejercicio {
    List<String> listaImagenes;
    String nombre;
    String? id;

    Ejercicio({
        required this.listaImagenes,
        required this.nombre,
        this.id,
    });

    factory Ejercicio.fromRawJson(String str) => Ejercicio.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Ejercicio.fromJson(Map<String, dynamic> json) => Ejercicio(
        listaImagenes: List<String>.from(json["listaImagenes"].map((x) => x)),
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "listaImagenes": List<dynamic>.from(listaImagenes.map((x) => x)),
        "nombre": nombre,
    };
}