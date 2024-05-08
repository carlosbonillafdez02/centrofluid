import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:provider/provider.dart';
import 'package:fl_centro_fluid/providers/providers.dart';

class BotonReserva extends StatefulWidget {
  final Clase clase;
  const BotonReserva({super.key, required this.clase});

  @override
  State<BotonReserva> createState() => _BotonReservaState();
}

class _BotonReservaState extends State<BotonReserva> {
  @override
  Widget build(BuildContext context) {
    final clasesService = Provider.of<ClasesService>(context);
    final Usuario usuario =
        Provider.of<ConnectedUserProvider>(context).activeUser;
    mostrarDialogo(String titulo, String cuerpo) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(titulo),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(10)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(cuerpo),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"))
              ],
            );
          });
    }

    return ElevatedButton(
      onPressed: () {
        if (widget.clase.listaClientes.length <
            widget.clase.capacidadClientes) {
          clasesService.realizarReservaClase(
              widget.clase.id!, usuario.id!);
          setState(() {});
          mostrarDialogo(
              "Reserva realizada", "Has hecho una reserva en esta clase");
        } // Actualiza el widget cuando cambia el estado
        else {
          mostrarDialogo("No se ha podido realizar la reserva",
              "La clase está llena, pruebe a reservar otra clase");
        }
      },
      child: Text(
        'Realizar Reserva',
        style: TextStyle(fontSize: 17),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
    );
  }
}
