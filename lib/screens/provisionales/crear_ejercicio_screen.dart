import 'package:fl_centro_fluid/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CrearEjercicioScreen extends StatelessWidget {
   
  const CrearEjercicioScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
         child: CrearEjercicio(),
      ),
    );
  }
}