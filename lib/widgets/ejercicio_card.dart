import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';

class EjercicioCard extends StatelessWidget {
  final Ejercicio ejercicio;
  final VoidCallback onTap;
  final bool isSelected;

  EjercicioCard(
      {required this.ejercicio, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
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
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    ejercicio.nombre,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 220 * ejercicio.listaImagenes.length.toDouble(),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ejercicio.listaImagenes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          alignment: Alignment.center,
                          child: Image.network(
                            ejercicio.listaImagenes[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
