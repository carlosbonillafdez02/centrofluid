import 'package:fl_centro_fluid/providers/providers.dart';
import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ClaseCard extends StatefulWidget {
  final Clase clase;

  const ClaseCard({Key? key, required this.clase}) : super(key: key);

  @override
  _ClaseCardState createState() => _ClaseCardState();
}

class _ClaseCardState extends State<ClaseCard> {
  bool showExercises = false;

  @override
  Widget build(BuildContext context) {
    final sesionesService = Provider.of<SesionesService>(context);
    final clasesService = Provider.of<ClasesService>(context);
    final Usuario usuario =
        Provider.of<ConnectedUserProvider>(context).activeUser;
    final formattedHour =
        DateFormat('HH:mm   dd/MM').format(widget.clase.fecha);

    return GestureDetector(
      onLongPress: () {
        if (usuario.rol == "entrenador") {
          _mostrarDialogoEliminarClase(context, widget.clase, clasesService);
        }
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedHour,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Row(
                    children: [
                      Text(
                        '${widget.clase.listaClientes.length}/${widget.clase.capacidadClientes}',
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.person_outline, size: 35),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                widget.clase.entrenador,
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showExercises = !showExercises;
                      });
                    },
                    child: Text(
                      showExercises ? 'Ocultar ejercicios' : 'Ver ejercicios',
                      style: TextStyle(fontSize: 17),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                  ),
                  if (usuario.rol == "entrenador")
                    BotonClientesReservados(
                      clientesReservados: widget.clase.listaClientes,
                      claseId: widget.clase.id!,
                    )
                  else if (widget.clase.fecha.isAfter(DateTime.now()) ||
                      widget.clase
                          .isSameDay(DateTime.now(), widget.clase.fecha))
                    if (!widget.clase.listaClientes.contains(usuario.id))
                      BotonReserva(clase: widget.clase)
                    else
                      BotonCancelarReserva(clase: widget.clase),
                ],
              ),
              if (showExercises)
                FutureBuilder<Sesion>(
                  future: sesionesService.getSesionById(widget.clase.sesion),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final sesion = snapshot.data;
                      return SesionCard(
                        sesion: sesion!,
                        onTap: () {},
                        isSelected: false,
                      );
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                        color: AppTheme.primary,
                      ));
                    }
                  },
                ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _mostrarDialogoEliminarClase(
      BuildContext context, Clase clase, ClasesService clasesService) async {
    final bool confirmacion = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar Clase'),
          content: Text('¿Está seguro de que desea eliminar esta clase?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmacion) {
      await clasesService.deleteClase(clase);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Clase eliminada correctamente')),
      );
    }
  }
}
