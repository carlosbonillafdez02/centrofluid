// Fecha comentada para una futura implementación
class Grupo {
  int? capacidadClientes;
  // List<Fecha>? fechas;
  List<String> listaClientes;
  String nombre;
  String? id;

  Grupo(
      {this.capacidadClientes,
      //this.fechas,
      required this.listaClientes,
      required this.nombre,
      this.id});

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
        capacidadClientes: json['capacidadClientes'] ?? 0,
        /*fechas: json['fechas'] != null
            ? List<Fecha>.from(
                json['fechas'].map((fecha) => Fecha.fromJson(fecha)))
            : [],*/
        listaClientes: json['listaClientes'] != null
            ? List<String>.from(json['listaClientes'])
            : [], // Comprueba si listaClientes es nula antes de mapear
        nombre: json['nombre']);
  }

  Map<String, dynamic> toJson() {
    return {
      'capacidadClientes': capacidadClientes,
      /*'fechas': fechas!.isNotEmpty
          ? fechas!.map((fecha) => fecha.toJson()).toList()
          : null,*/
      'listaClientes': listaClientes,
      'nombre': nombre
    };
  }
}

/*
class Fecha {
  int diaSemana;
  String hora;

  Fecha({required this.diaSemana, required this.hora});

  factory Fecha.fromJson(Map<String, dynamic> json) {
    return Fecha(
      diaSemana: json['diaSemana'],
      hora: json['hora'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diaSemana': diaSemana,
      'hora': hora,
    };
  }
}

String getNombreDiaSemana(int numeroDia) {
  switch (numeroDia) {
    case 1:
      return 'lunes';
    case 2:
      return 'martes';
    case 3:
      return 'miércoles';
    case 4:
      return 'jueves';
    case 5:
      return 'viernes';
    case 6:
      return 'sábado';
    case 7:
      return 'domingo';
    default:
      return 'Día no válido';
  }
}
*/