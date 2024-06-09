import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:provider/provider.dart';
import 'package:fl_centro_fluid/providers/providers.dart';

class BotonCancelarReserva extends StatefulWidget {
  final Clase clase;
  const BotonCancelarReserva({Key? key, required this.clase}) : super(key: key);

  @override
  State<BotonCancelarReserva> createState() => _BotonCancelarReservaState();
}

class _BotonCancelarReservaState extends State<BotonCancelarReserva> {
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

    void mostrarDialogoConfirmacion(
        String titulo, String cuerpo, VoidCallback onConfirm) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(titulo),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
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
                onPressed: () {
                  Navigator.pop(context); // Cierra el diálogo
                },
                child: const Text("Atrás"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el diálogo
                  onConfirm(); // Ejecuta la acción de confirmación
                },
                child: const Text("Confirmar"),
              ),
            ],
          );
        },
      );
    }

    return ElevatedButton(
      onPressed: () async {
        mostrarDialogoConfirmacion(
          "Confirmar cancelación",
          "¿Estás seguro de que quieres cancelar tu reserva en esta clase?",
          () async {
            if (await clasesService.cancelarReservaClase(
                widget.clase.id!, usuario.id!)) {
              setState(() {});
              mostrarDialogo(
                "Reserva cancelada",
                "Has cancelado tu reserva en esta clase",
              );
            } else {
              mostrarDialogo(
                "Error al cancelar",
                "No tienes una reserva en esta clase.",
              );
            }
          },
        );
      },
      child: Text(
        'Cancelar Reserva',
        style: TextStyle(fontSize: 17),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
    );
  }
}
