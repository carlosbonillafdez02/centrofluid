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
    final formattedHour = DateFormat('HH:mm').format(widget.clase.fecha);

    return Card(
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
              '${widget.clase.entrenador}',
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
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                ),
                BotonReserva(clase: widget.clase),
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
                    // Muestra un indicador de carga mientras se obtiene la sesión
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
    );
  }
}
