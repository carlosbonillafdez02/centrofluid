import 'dart:convert';

class Sesion {
  List<EjercicioConRepYSeries> ejercicios;
  String nombre;
  String? id;

  Sesion({
    required this.ejercicios,
    required this.nombre,
    this.id,
  });

  factory Sesion.fromRawJson(String str) => Sesion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sesion.fromJson(Map<String, dynamic> json) => Sesion(
        ejercicios: List<EjercicioConRepYSeries>.from(
            json["ejercicios"].map((x) => EjercicioConRepYSeries.fromJson(x))),
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "ejercicios": List<dynamic>.from(ejercicios.map((x) => x.toJson())),
        "nombre": nombre,
      };
}

class EjercicioConRepYSeries {
  String id;
  String nombre;
  String repeticionesSeries;

  EjercicioConRepYSeries({
    required this.id,
    required this.nombre,
    required this.repeticionesSeries,
  });

  factory EjercicioConRepYSeries.fromRawJson(String str) =>
      EjercicioConRepYSeries.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EjercicioConRepYSeries.fromJson(Map<String, dynamic> json) =>
      EjercicioConRepYSeries(
        id: json["id"],
        nombre: json["nombre"] ?? json["id"],
        repeticionesSeries: json["repeticionesSeries"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "repeticionesSeries": repeticionesSeries,
      };
}
