import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:provider/provider.dart';

class SesionCard extends StatelessWidget {
  final Sesion sesion;
  final VoidCallback onTap;
  final bool isSelected;

  const SesionCard(
      {Key? key,
      required this.sesion,
      required this.onTap,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ejerciciosService = Provider.of<EjerciciosService>(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isSelected
              ? BorderSide(color: AppTheme.primary, width: 4)
              : BorderSide.none,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${sesion.nombre}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ExpansionTile(
                title: Text('Ejercicios (${sesion.ejercicios.length})'),
                children: [
                  ...sesion.ejercicios.map((ejer) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: FutureBuilder<Ejercicio>(
                        future: ejerciciosService.getEjercicioById(ejer.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final ejercicio = snapshot.data;
                            return EjercicioCard(
                              ejercicio: ejercicio!,
                              onTap: () {},
                              isSelected: false,
                            );
                          } else {
                            // Muestra un indicador de carga mientras se obtiene el ejercicio
                            return Center(
                                child: CircularProgressIndicator(
                              color: AppTheme.primary,
                            ));
                          }
                        },
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
