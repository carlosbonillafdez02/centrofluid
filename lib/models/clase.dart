import 'dart:convert';

class Clase {
  int capacidadClientes;
  String entrenador;
  DateTime fecha;
  List<String> listaClientes;
  String sesion;
  String? id;

  Clase({
    required this.capacidadClientes,
    required this.entrenador,
    required this.fecha,
    required this.listaClientes,
    required this.sesion,
    this.id,
  });

  factory Clase.fromRawJson(String str) => Clase.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Clase.fromJson(Map<String, dynamic> json) => Clase(
        capacidadClientes: json["capacidadClientes"],
        entrenador: json["entrenador"],
        fecha: DateTime.parse(json["fecha"]),
        listaClientes: json["listaClientes"] != null
            ? List<String>.from(json["listaClientes"].map((x) => x))
            : [], // Comprueba si listaClientes es nula antes de mapear
        sesion: json["sesion"],
      );

  Map<String, dynamic> toJson() => {
        "capacidadClientes": capacidadClientes,
        "entrenador": entrenador,
        "fecha": fecha.toIso8601String(),
        "listaClientes": listaClientes.isNotEmpty
            ? List<dynamic>.from(listaClientes.map((x) => x))
            : null, // Verifica si listaClientes está vacía antes de incluirla en JSON
        "sesion": sesion,
      };

  // Comprueba si dos fechas son el mismo día
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
